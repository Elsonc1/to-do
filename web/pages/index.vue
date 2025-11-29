<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-4xl mx-auto px-4">
      <div class="bg-white rounded-lg shadow-md p-6">
        <div class="flex justify-between items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-800">Minhas Tarefas</h1>
          <div class="flex gap-2">
            <button
              @click="showCreateModal = true"
              class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
            >
              + Nova Tarefa
            </button>
            <button
              @click="handleLogout"
              class="bg-gray-600 hover:bg-gray-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
            >
              Sair
            </button>
          </div>
        </div>

        <!-- Busca -->
        <div class="mb-4">
          <input
            v-model="searchTerm"
            @input="handleSearch"
            type="text"
            placeholder="Buscar tarefas por título ou descrição..."
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <!-- Filtros -->
        <div class="mb-6 flex gap-2">
          <button
            @click="filterStatus = null; loadTasks()"
            :class="[
              'px-4 py-2 rounded-lg font-medium transition-colors',
              filterStatus === null
                ? 'bg-blue-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            ]"
          >
            Todas
          </button>
          <button
            @click="filterStatus = 'pendente'; loadTasks()"
            :class="[
              'px-4 py-2 rounded-lg font-medium transition-colors',
              filterStatus === 'pendente'
                ? 'bg-yellow-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            ]"
          >
            Pendentes
          </button>
          <button
            @click="filterStatus = 'em_andamento'; loadTasks()"
            :class="[
              'px-4 py-2 rounded-lg font-medium transition-colors',
              filterStatus === 'em_andamento'
                ? 'bg-orange-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            ]"
          >
            Em Andamento
          </button>
          <button
            @click="filterStatus = 'concluida'; loadTasks()"
            :class="[
              'px-4 py-2 rounded-lg font-medium transition-colors',
              filterStatus === 'concluida'
                ? 'bg-green-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            ]"
          >
            Concluídas
          </button>
        </div>

        <!-- Lista de Tarefas -->
        <div v-if="loading" class="text-center py-8">
          <p class="text-gray-500">Carregando tarefas...</p>
        </div>

        <div v-else-if="filteredTasks.length === 0" class="text-center py-8">
          <p class="text-gray-500">Nenhuma tarefa encontrada.</p>
        </div>

        <div v-else class="space-y-4">
          <TaskCard
            v-for="task in filteredTasks"
            :key="task.id"
            :task="task"
            @edit="handleEdit"
            @delete="handleDelete"
            @update-status="handleUpdateStatus"
          />
        </div>
      </div>
    </div>

    <!-- Modal de Criar/Editar -->
    <TaskModal
      v-if="showCreateModal || editingTask"
      :task="editingTask"
      @close="closeModal"
      @save="handleSave"
    />
  </div>
</template>

<script setup lang="ts">
import { Task } from '~/composables/useTasks';

definePageMeta({
  middleware: 'auth'
});

const { fetchTasks, deleteTask, updateTask } = useTasks();
const { logout } = useAuth();

const tasks = ref<Task[]>([]);
const loading = ref(true);
const showCreateModal = ref(false);
const editingTask = ref<Task | null>(null);
const filterStatus = ref<string | null>(null);
const searchTerm = ref('');
let searchTimeout: NodeJS.Timeout | null = null;

const filteredTasks = computed(() => {
  return tasks.value;
});

const loadTasks = async () => {
  try {
    loading.value = true;
    tasks.value = await fetchTasks(
      searchTerm.value || undefined,
      filterStatus.value || undefined
    );
  } catch (error) {
    console.error('Erro ao carregar tarefas:', error);
  } finally {
    loading.value = false;
  }
};

const handleSearch = () => {
  if (searchTimeout) {
    clearTimeout(searchTimeout);
  }
  searchTimeout = setTimeout(() => {
    loadTasks();
  }, 500);
};

const handleEdit = (task: Task) => {
  editingTask.value = task;
};

const handleDelete = async (id: string) => {
  if (confirm('Tem certeza que deseja excluir esta tarefa?')) {
    try {
      await deleteTask(id);
      await loadTasks();
    } catch (error) {
      alert('Erro ao excluir tarefa');
    }
  }
};

const handleUpdateStatus = async (id: string, status: string) => {
  try {
    await updateTask(id, { status: status as any });
    await loadTasks();
  } catch (error) {
    alert('Erro ao atualizar status da tarefa');
  }
};

const handleSave = async () => {
  await loadTasks();
  closeModal();
};

const closeModal = () => {
  showCreateModal.value = false;
  editingTask.value = null;
};

const handleLogout = () => {
  logout();
};

onMounted(() => {
  loadTasks();
});
</script>

