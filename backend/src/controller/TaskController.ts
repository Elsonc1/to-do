import { Request, Response } from 'express';
import { TaskService } from '../service/TaskService';
import { TaskStatus } from '../entity/Task';

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
}

