import { TaskService } from '../service/TaskService';
import { AppDataSource } from '../data-source';
import { Task, TaskStatus } from '../entity/Task';

// Mock do TypeORM
jest.mock('../data-source', () => ({
  AppDataSource: {
    getRepository: jest.fn(),
    initialize: jest.fn().mockResolvedValue(true)
  }
}));

describe('TaskService', () => {
  let taskService: TaskService;
  let mockRepository: any;

  beforeEach(() => {
    mockRepository = {
      create: jest.fn(),
      save: jest.fn(),
      find: jest.fn(),
      findOne: jest.fn(),
      delete: jest.fn(),
      createQueryBuilder: jest.fn(() => ({
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        getMany: jest.fn()
      }))
    };

    (AppDataSource.getRepository as jest.Mock).mockReturnValue(mockRepository);
    taskService = new TaskService();
  });

  describe('create', () => {
    it('deve criar uma nova tarefa', async () => {
      const taskData = {
        titulo: 'Nova Tarefa',
        descricao: 'Descrição',
        status: TaskStatus.PENDENTE
      };

      const createdTask = { id: '1', ...taskData };
      mockRepository.create.mockReturnValue(createdTask);
      mockRepository.save.mockResolvedValue(createdTask);

      const result = await taskService.create(taskData);

      expect(mockRepository.create).toHaveBeenCalledWith(taskData);
      expect(mockRepository.save).toHaveBeenCalledWith(createdTask);
      expect(result).toEqual(createdTask);
    });
  });

  describe('findAll', () => {
    it('deve retornar todas as tarefas', async () => {
      const tasks = [
        { id: '1', titulo: 'Tarefa 1' },
        { id: '2', titulo: 'Tarefa 2' }
      ];

      const queryBuilder = {
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        getMany: jest.fn().mockResolvedValue(tasks)
      };

      mockRepository.createQueryBuilder.mockReturnValue(queryBuilder);

      const result = await taskService.findAll();

      expect(queryBuilder.orderBy).toHaveBeenCalledWith('task.dataCriacao', 'DESC');
      expect(result).toEqual(tasks);
    });
  });

  describe('delete', () => {
    it('deve deletar uma tarefa existente', async () => {
      mockRepository.delete.mockResolvedValue({ affected: 1 });

      const result = await taskService.delete('1');

      expect(mockRepository.delete).toHaveBeenCalledWith('1');
      expect(result).toBe(true);
    });

    it('deve retornar false se a tarefa não existir', async () => {
      mockRepository.delete.mockResolvedValue({ affected: 0 });

      const result = await taskService.delete('999');

      expect(result).toBe(false);
    });
  });
});

