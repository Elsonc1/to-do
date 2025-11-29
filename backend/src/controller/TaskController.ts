import { Request, Response } from 'express';
import { TaskService } from '../service/TaskService';
import { TaskStatus } from '../entity/Task';
import path from 'path';
import fs from 'fs';

export class TaskController {
  private taskService: TaskService;

  constructor() {
    this.taskService = new TaskService();
  }

  async create(req: Request, res: Response): Promise<void> {
    try {
      const { titulo, descricao, status } = req.body;

      if (!titulo) {
        res.status(400).json({ error: 'Título é obrigatório' });
        return;
      }

      const task = await this.taskService.create({
        titulo,
        descricao,
        status: status || TaskStatus.PENDENTE
      });

      res.status(201).json(task);
    } catch (error) {
      console.error('Erro ao criar tarefa:', error);
      res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  async findAll(req: Request, res: Response): Promise<void> {
    try {
      const { search, status } = req.query;
      const tasks = await this.taskService.findAll(
        search as string | undefined,
        status as TaskStatus | undefined
      );
      res.json(tasks);
    } catch (error) {
      console.error('Erro ao listar tarefas:', error);
      res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  async findOne(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const task = await this.taskService.findOne(id);

      if (!task) {
        res.status(404).json({ error: 'Tarefa não encontrada' });
        return;
      }

      res.json(task);
    } catch (error) {
      console.error('Erro ao buscar tarefa:', error);
      res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  async update(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { titulo, descricao, status } = req.body;

      const task = await this.taskService.update(id, {
        titulo,
        descricao,
        status
      });

      if (!task) {
        res.status(404).json({ error: 'Tarefa não encontrada' });
        return;
      }

      res.json(task);
    } catch (error) {
      console.error('Erro ao atualizar tarefa:', error);
      res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  async delete(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const deleted = await this.taskService.delete(id);

      if (!deleted) {
        res.status(404).json({ error: 'Tarefa não encontrada' });
        return;
      }

      res.status(204).send();
    } catch (error) {
      console.error('Erro ao excluir tarefa:', error);
      res.status(500).json({ error: 'Erro interno do servidor' });
    }
  }

  async uploadFile(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const file = req.file;

      if (!file) {
        res.status(400).json({ error: 'Nenhum arquivo enviado' });
        return;
      }

      const fileUrl = `/uploads/${file.filename}`;
      const task = await this.taskService.update(id, {
        arquivo: fileUrl
      });

      if (!task) {
        fs.unlinkSync(file.path);
        res.status(404).json({ error: 'Tarefa não encontrada' });
        return;
      }
      if (task.arquivo && task.arquivo !== fileUrl) {
        const oldFilePath = path.join(__dirname, '../..', task.arquivo);
        if (fs.existsSync(oldFilePath)) {
          fs.unlinkSync(oldFilePath);
        }
      }

      res.json({ ...task, arquivo: fileUrl });
    } catch (error: any) {
      console.error('Erro ao fazer upload:', error);
      
      if (req.file) {
        fs.unlinkSync(req.file.path);
      }

      if (error.message.includes('Tipo de arquivo')) {
        res.status(400).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Erro interno do servidor' });
      }
    }
  }
}
