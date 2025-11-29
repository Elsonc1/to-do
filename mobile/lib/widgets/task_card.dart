import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

Color _getStatusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.pendente:
      return Colors.orange;
    case TaskStatus.emAndamento:
      return Colors.blue;
    case TaskStatus.concluida:
      return Colors.green;
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            if (task.descricao != null && task.descricao!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.descricao!,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status.label,
                    style: TextStyle(
                      color: _getStatusColor(task.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                DropdownButton<TaskStatus>(
                  value: task.status,
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      onStatusChanged(newStatus);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Criada em: ${_formatDate(task.dataCriacao)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (task.dataConclusao != null)
              Text(
                'Concluída em: ${_formatDate(task.dataConclusao!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}

