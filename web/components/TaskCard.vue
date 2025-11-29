<template>
  <div
    :class="[
      'border rounded-lg p-4 transition-all hover:shadow-md',
      getStatusColor(task.status)
    ]"
  >
    <div class="flex justify-between items-start mb-2">
      <h3 class="text-xl font-semibold text-gray-800">{{ task.titulo }}</h3>
      <div class="flex gap-2">
        <button
          @click="$emit('edit', task)"
          class="text-blue-600 hover:text-blue-800 transition-colors"
          title="Editar"
        >
          ✏️
        </button>
        <button
          @click="$emit('delete', task.id)"
          class="text-red-600 hover:text-red-800 transition-colors"
          title="Excluir"
        >
          🗑️
        </button>
      </div>
    </div>

    <p v-if="task.descricao" class="text-gray-600 mb-3">{{ task.descricao }}</p>

    <div v-if="task.arquivo" class="mb-3">
      <a
        :href="getFileUrl(task.arquivo)"
        target="_blank"
        class="text-blue-600 hover:text-blue-800 text-sm underline flex items-center gap-1"
      >
        📎 Anexo disponível
      </a>
    </div>

    <div class="flex items-center justify-between">
      <div class="flex items-center gap-4">
        <span :class="['px-3 py-1 rounded-full text-sm font-medium', getStatusBadgeClass(task.status)]">
          {{ getStatusLabel(task.status) }}
        </span>
        <span class="text-sm text-gray-500">
          Criada em: {{ formatDate(task.dataCriacao) }}
        </span>
        <span v-if="task.dataConclusao" class="text-sm text-gray-500">
          Concluída em: {{ formatDate(task.dataConclusao) }}
        </span>
      </div>

      <div class="flex gap-2">
        <select
          :value="task.status"
          @change="handleStatusChange($event)"
          class="px-3 py-1 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="pendente">Pendente</option>
          <option value="em_andamento">Em Andamento</option>
          <option value="concluida">Concluída</option>
        </select>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Task } from '~/composables/useTasks';

const props = defineProps<{
  task: Task;
}>();

const emit = defineEmits<{
  edit: [task: Task];
  delete: [id: string];
  'update-status': [id: string, status: string];
}>();

const config = useRuntimeConfig();

const getFileUrl = (arquivo: string) => {
  const apiBase = config.public.apiBase;
  return arquivo.startsWith('http') ? arquivo : `${apiBase}${arquivo}`;
};

const handleStatusChange = (event: Event) => {
  const target = event.target as HTMLSelectElement;
  emit('update-status', props.task.id, target.value);
};

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    pendente: 'Pendente',
    em_andamento: 'Em Andamento',
    concluida: 'Concluída'
  };
  return labels[status] || status;
};

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    pendente: 'bg-yellow-100 text-yellow-800',
    em_andamento: 'bg-orange-100 text-orange-800',
    concluida: 'bg-green-100 text-green-800'
  };
  return classes[status] || 'bg-gray-100 text-gray-800';
};

const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    pendente: 'border-yellow-300 bg-yellow-50',
    em_andamento: 'border-orange-300 bg-orange-50',
    concluida: 'border-green-300 bg-green-50'
  };
  return colors[status] || 'border-gray-300 bg-white';
};

const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};
</script>

