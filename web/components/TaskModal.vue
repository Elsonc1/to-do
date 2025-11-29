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

        <div>
          <label for="arquivo" class="block text-sm font-medium text-gray-700 mb-1">
            Anexar Arquivo (opcional)
          </label>
          <input
            id="arquivo"
            type="file"
            @change="handleFileChange"
            accept="image/*,.pdf,.doc,.docx,.txt"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <p v-if="selectedFile" class="text-sm text-gray-600 mt-1">
            Arquivo selecionado: {{ selectedFile.name }}
          </p>
          <p v-if="props.task?.arquivo" class="text-sm text-blue-600 mt-1">
            <a :href="getFileUrl(props.task.arquivo)" target="_blank" class="underline">
              Ver arquivo atual
            </a>
          </p>
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

const { createTask, updateTask, uploadFile } = useTasks();
const config = useRuntimeConfig();

const form = ref<CreateTaskDTO | UpdateTaskDTO>({
  titulo: props.task?.titulo || '',
  descricao: props.task?.descricao || '',
  status: props.task?.status || 'pendente'
});

const selectedFile = ref<File | null>(null);

const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files[0]) {
    selectedFile.value = target.files[0];
  }
};

const getFileUrl = (arquivo: string) => {
  const apiBase = config.public.apiBase;
  return arquivo.startsWith('http') ? arquivo : `${apiBase}${arquivo}`;
};

const handleSubmit = async () => {
  try {
    let savedTask: Task;
    
    if (props.task) {
      // Atualizar tarefa existente
      savedTask = await updateTask(props.task.id, form.value);
      // Se houver arquivo selecionado, fazer upload
      if (selectedFile.value) {
        await uploadFile(savedTask.id, selectedFile.value);
      }
    } else {
      // Criar nova tarefa
      savedTask = await createTask(form.value as CreateTaskDTO);
      // Se houver arquivo selecionado, fazer upload na tarefa recém-criada
      if (selectedFile.value && savedTask.id) {
        await uploadFile(savedTask.id, selectedFile.value);
      }
    }
    emit('save');
  } catch (error) {
    console.error('Erro ao salvar tarefa:', error);
    alert('Erro ao salvar tarefa');
  }
};
</script>

