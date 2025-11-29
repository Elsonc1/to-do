import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import '../models/task.dart';
import 'auth_service.dart';

class TaskService {
  static const String baseUrl = 'http://localhost:3000';
  
  final AuthService _authService = AuthService();

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
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(uri, headers: headers);

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
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(Uri.parse('$baseUrl/tasks/$id'), headers: headers);

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
      final headers = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: headers,
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

      final headers = await _authService.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: headers,
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
      final headers = await _authService.getAuthHeaders();
      final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'), headers: headers);

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

  Future<Task> uploadFile(
    String taskId, {
    File? file,
    Uint8List? fileBytes,
    required String fileName,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/tasks/$taskId/upload'),
      );
      
      if (headers.containsKey('Authorization')) {
        request.headers['Authorization'] = headers['Authorization']!;
      }

      if (kIsWeb && fileBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'arquivo',
            fileBytes,
            filename: fileName,
          ),
        );
      } else if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'arquivo',
            file.path,
            filename: fileName,
          ),
        );
      } else {
        throw Exception('Arquivo não fornecido');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final taskData = json.decode(response.body) as Map<String, dynamic>;
        return Task.fromJson(taskData);
      } else if (response.statusCode == 404) {
        throw Exception('Tarefa não encontrada');
      } else {
        throw Exception('Falha ao fazer upload: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer upload: $e');
    }
  }
}
