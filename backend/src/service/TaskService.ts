import { Repository } from 'typeorm';
import { AppDataSource } from '../data-source';
import { Task, TaskStatus } from '../entity/Task';

interface CreateTaskDTO {
  titulo: string;
  descricao?: string;
  status?: TaskStatus;
}

interface UpdateTaskDTO {
  titulo?: string;
  descricao?: string;
  status?: TaskStatus;
  dataConclusao?: Date;
}

export class TaskService {
  private taskRepository: Repository<Task>;

  constructor() {
    this.taskRepository = AppDataSource.getRepository(Task);
  }

  async create(data: CreateTaskDTO): Promise<Task> {
    const task = this.taskRepository.create(data);
    return await this.taskRepository.save(task);
  }

  async findAll(search?: string, status?: TaskStatus): Promise<Task[]> {
    const queryBuilder = this.taskRepository.createQueryBuilder('task');

    if (search) {
      queryBuilder.where(
        '(task.titulo ILIKE :search OR task.descricao ILIKE :search)',
        { search: `%${search}%` }
      );
    }

    if (status) {
      if (search) {
        queryBuilder.andWhere('task.status = :status', { status });
      } else {
        queryBuilder.where('task.status = :status', { status });
      }
    }

    queryBuilder.orderBy('task.dataCriacao', 'DESC');

    return await queryBuilder.getMany();
  }

  async findOne(id: string): Promise<Task | null> {
    return await this.taskRepository.findOne({ where: { id } });
  }

  async update(id: string, data: UpdateTaskDTO): Promise<Task | null> {
    const task = await this.taskRepository.findOne({ where: { id } });

    if (!task) {
      return null;
    }

    // Se o status foi alterado para concluída, definir data_conclusao
    if (data.status === TaskStatus.CONCLUIDA && task.status !== TaskStatus.CONCLUIDA) {
      task.dataConclusao = new Date();
    } else if (data.status && data.status !== TaskStatus.CONCLUIDA && task.status === TaskStatus.CONCLUIDA) {
      // Se mudou de concluída para outro status, limpar data_conclusao
      task.dataConclusao = undefined;
    }

    // Atualizar apenas os campos fornecidos
    if (data.titulo !== undefined) {
      task.titulo = data.titulo;
    }
    if (data.descricao !== undefined) {
      task.descricao = data.descricao;
    }
    if (data.status !== undefined) {
      task.status = data.status;
    }
    
    return await this.taskRepository.save(task);
  }

  async delete(id: string): Promise<boolean> {
    const result = await this.taskRepository.delete(id);
    return (result.affected ?? 0) > 0;
  }
}

