import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
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
  File? _selectedFile;
  String? _fileName;
  Uint8List? _fileBytes; // Para web

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
          final updatedTask = await _taskService.updateTask(
            id: widget.task!.id,
            titulo: _tituloController.text,
            descricao: _descricaoController.text.isEmpty
                ? null
                : _descricaoController.text,
            status: _selectedStatus,
          );
          
          // Se houver arquivo selecionado, fazer upload
          if (_selectedFile != null || _fileBytes != null) {
            await _taskService.uploadFile(
              updatedTask.id,
              file: _selectedFile,
              fileBytes: _fileBytes,
              fileName: _fileName ?? 'arquivo',
            );
          }
        } else {
          // Criar nova tarefa
          final newTask = await _taskService.createTask(
            titulo: _tituloController.text,
            descricao: _descricaoController.text.isEmpty
                ? null
                : _descricaoController.text,
            status: _selectedStatus,
          );
          
          // Se houver arquivo selecionado, fazer upload
          if (_selectedFile != null || _fileBytes != null) {
            await _taskService.uploadFile(
              newTask.id,
              file: _selectedFile,
              fileBytes: _fileBytes,
              fileName: _fileName ?? 'arquivo',
            );
          }
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

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        final pickedFile = result.files.single;
        setState(() {
          if (kIsWeb) {
            // Na web, usar bytes
            _fileBytes = pickedFile.bytes;
            _selectedFile = null;
          } else {
            // No mobile, usar path
            if (pickedFile.path != null) {
              _selectedFile = File(pickedFile.path!);
              _fileBytes = null;
            }
          }
          _fileName = pickedFile.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar arquivo: $e')),
        );
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
                  // Upload de arquivo (ao criar ou editar)
                  OutlinedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: Text(_fileName ?? 'Anexar arquivo (opcional)'),
                  ),
                  if (_fileName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Arquivo selecionado: $_fileName',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
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

