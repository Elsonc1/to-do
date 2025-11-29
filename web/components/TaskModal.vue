<template>
  <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl p-6 w-full max-w-md">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-2xl font-bold text-gray-800">
          {{ task ? 'Editar Tarefa' : 'Nova Tarefa' }}
        </h2>
        <button
          @click="$emit('close')"
          class="text-gray-500 hover:text-gray-700 text-2xl"
        >
          ×
        </button>
      </div>

      <form @submit.prevent="handleSubmit" class="space-y-4">
        <div>
          <label for="titulo" class="block text-sm font-medium text-gray-700 mb-1">
            Título *
          </label>
          <input
            id="titulo"
            v-model="form.titulo"
            type="text"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Digite o título da tarefa"
          />
        </div>

        <div>
          <label for="descricao" class="block text-sm font-medium text-gray-700 mb-1">
            Descrição
          </label>
          <textarea
            id="descricao"
            v-model="form.descricao"
            rows="4"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Digite a descrição da tarefa (opcional)"
          ></textarea>
        </div>

        <div>
          <label for="status" class="block text-sm font-medium text-gray-700 mb-1">
            Status
          </label>
          <select
            id="status"
            v-model="form.status"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="pendente">Pendente</option>
            <option value="em_andamento">Em Andamento</option>
            <option value="concluida">Concluída</option>
          </select>
        </div>

        <div class="flex gap-3 pt-4">
          <button
            type="button"
            @click="$emit('close')"
            class="flex-1 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
          >
            Cancelar
          </button>
          <button
            type="submit"
            class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            Salvar
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Task, CreateTaskDTO, UpdateTaskDTO } from '~/composables/useTasks';

const props = defineProps<{
  task?: Task | null;
}>();

const emit = defineEmits<{
  close: [];
  save: [];
}>();

const { createTask, updateTask } = useTasks();

const form = ref<CreateTaskDTO | UpdateTaskDTO>({
  titulo: props.task?.titulo || '',
  descricao: props.task?.descricao || '',
  status: props.task?.status || 'pendente'
});

const handleSubmit = async () => {
  try {
    if (props.task) {
      await updateTask(props.task.id, form.value);
    } else {
      await createTask(form.value as CreateTaskDTO);
    }
    emit('save');
  } catch (error) {
    alert('Erro ao salvar tarefa');
  }
};
</script>

