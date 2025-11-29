import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _searchController = TextEditingController();
  List<Task> _tasks = [];
  bool _loading = true;
  TaskStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _loading = true;
    });

    try {
      final tasks = await _taskService.fetchTasks(
        search: _searchController.text.isEmpty ? null : _searchController.text,
        status: _filterStatus,
      );
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar tarefas: $e')),
        );
      }
    }
  }

  List<Task> get _filteredTasks {
    return _tasks;
  }

  Future<void> _deleteTask(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _taskService.deleteTask(id);
        _loadTasks();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa excluída com sucesso')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir tarefa: $e')),
          );
        }
      }
    }
  }

  Future<void> _updateTaskStatus(Task task, TaskStatus newStatus) async {
    try {
      await _taskService.updateTask(
        id: task.id,
        status: newStatus,
      );
      _loadTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar status: $e')),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final authService = AuthService();
    await authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tarefas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                          _loadTasks();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted && _searchController.text == value) {
                    _loadTasks();
                  }
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterButton('Todas', null),
                _buildFilterButton('Pendentes', TaskStatus.pendente),
                _buildFilterButton('Em Andamento', TaskStatus.emAndamento),
                _buildFilterButton('Concluídas', TaskStatus.concluida),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma tarefa encontrada',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = _filteredTasks[index];
                            return TaskCard(
                              task: task,
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskFormScreen(task: task),
                                  ),
                                );
                                if (result == true) {
                                  _loadTasks();
                                }
                              },
                              onDelete: () => _deleteTask(task.id),
                              onStatusChanged: (newStatus) =>
                                  _updateTaskStatus(task, newStatus),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButton(String label, TaskStatus? status) {
    final isSelected = _filterStatus == status;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _filterStatus = status;
        });
        _loadTasks();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}

