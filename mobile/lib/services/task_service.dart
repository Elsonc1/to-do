import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  static const String baseUrl = 'http://localhost:3000'; // Para Android Emulator
  // Para iOS Simulator ou dispositivo físico, use: 'http://localhost:3002' ou seu IP local

  Future<List<Task>> fetchTasks({String? search, TaskStatus? status}) async {
    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (status != null) {
        queryParams['status'] = status.value;
      }

      final uri = Uri.parse('$baseUrl/tasks').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar tarefas');
      }
    } catch (e) {
      throw Exception('Erro ao buscar tarefas: $e');
    }
  }

  Future<Task> fetchTask(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks/$id'));

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Tarefa não encontrada');
      } else {
        throw Exception('Falha ao carregar tarefa');
      }
    } catch (e) {
      throw Exception('Erro ao buscar tarefa: $e');
    }
  }

  Future<Task> createTask({
    required String titulo,
    String? descricao,
    TaskStatus status = TaskStatus.pendente,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'titulo': titulo,
          'descricao': descricao,
          'status': status.value,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return Task.fromJson(responseData as Map<String, dynamic>);
      } else {
        throw Exception('Falha ao criar tarefa: Status ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao criar tarefa: $e');
    }
  }

  Future<Task> updateTask({
    required String id,
    String? titulo,
    String? descricao,
    TaskStatus? status,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (titulo != null) body['titulo'] = titulo;
      if (descricao != null) body['descricao'] = descricao;
      if (status != null) body['status'] = status.value;

      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Tarefa não encontrada');
      } else {
        throw Exception('Falha ao atualizar tarefa');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Tarefa não encontrada');
      } else {
        throw Exception('Falha ao excluir tarefa');
      }
    } catch (e) {
      throw Exception('Erro ao excluir tarefa: $e');
    }
  }
}

