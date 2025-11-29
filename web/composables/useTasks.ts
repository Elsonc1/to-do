export interface Task {
  id: string;
  titulo: string;
  descricao?: string;
  status: 'pendente' | 'em_andamento' | 'concluida';
  dataCriacao: string;
  dataConclusao?: string;
}

export interface CreateTaskDTO {
  titulo: string;
  descricao?: string;
  status?: 'pendente' | 'em_andamento' | 'concluida';
}

export interface UpdateTaskDTO {
  titulo?: string;
  descricao?: string;
  status?: 'pendente' | 'em_andamento' | 'concluida';
}

export const useTasks = () => {
  const config = useRuntimeConfig();
  const apiBase = config.public.apiBase;

  const fetchTasks = async (search?: string, status?: string): Promise<Task[]> => {
    try {
      const params: Record<string, string> = {};
      if (search) params.search = search;
      if (status) params.status = status;

      const queryString = new URLSearchParams(params).toString();
      const url = queryString ? `${apiBase}/tasks?${queryString}` : `${apiBase}/tasks`;
      
      const response = await $fetch<Task[]>(url);
      return response;
    } catch (error) {
      console.error('Erro ao buscar tarefas:', error);
      throw error;
    }
  };

  const fetchTask = async (id: string): Promise<Task> => {
    try {
      const response = await $fetch<Task>(`${apiBase}/tasks/${id}`);
      return response;
    } catch (error) {
      console.error('Erro ao buscar tarefa:', error);
      throw error;
    }
  };

  const createTask = async (data: CreateTaskDTO): Promise<Task> => {
    try {
      const response = await $fetch<Task>(`${apiBase}/tasks`, {
        method: 'POST',
        body: data
      });
      return response;
    } catch (error) {
      console.error('Erro ao criar tarefa:', error);
      throw error;
    }
  };

  const updateTask = async (id: string, data: UpdateTaskDTO): Promise<Task> => {
    try {
      const response = await $fetch<Task>(`${apiBase}/tasks/${id}`, {
        method: 'PUT',
        body: data
      });
      return response;
    } catch (error) {
      console.error('Erro ao atualizar tarefa:', error);
      throw error;
    }
  };

  const deleteTask = async (id: string): Promise<void> => {
    try {
      await $fetch(`${apiBase}/tasks/${id}`, {
        method: 'DELETE'
      });
    } catch (error) {
      console.error('Erro ao excluir tarefa:', error);
      throw error;
    }
  };

  return {
    fetchTasks,
    fetchTask,
    createTask,
    updateTask,
    deleteTask
  };
};

