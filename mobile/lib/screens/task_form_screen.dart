import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  TaskStatus _selectedStatus = TaskStatus.pendente;
  final TaskService _taskService = TaskService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _tituloController.text = widget.task!.titulo;
      _descricaoController.text = widget.task!.descricao ?? '';
      _selectedStatus = widget.task!.status;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        if (widget.task != null) {
          // Atualizar tarefa existente
          await _taskService.updateTask(
            id: widget.task!.id,
            titulo: _tituloController.text,
            descricao: _descricaoController.text.isEmpty
                ? null
                : _descricaoController.text,
            status: _selectedStatus,
          );
        } else {
          // Criar nova tarefa
          await _taskService.createTask(
            titulo: _tituloController.text,
            descricao: _descricaoController.text.isEmpty
                ? null
                : _descricaoController.text,
            status: _selectedStatus,
          );
        }

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.task != null
                  ? 'Tarefa atualizada com sucesso'
                  : 'Tarefa criada com sucesso'),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _loading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar tarefa: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatus = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ),
    );
  }
}

