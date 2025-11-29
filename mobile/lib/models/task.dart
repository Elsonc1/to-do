class Task {
  final String id;
  final String titulo;
  final String? descricao;
  final TaskStatus status;
  final DateTime dataCriacao;
  final DateTime? dataConclusao;
  final String? arquivo;

  Task({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.status,
    required this.dataCriacao,
    this.dataConclusao,
    this.arquivo,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
      descricao: json['descricao'] as String?,
      status: TaskStatus.fromString(json['status'] as String? ?? 'pendente'),
      dataCriacao: json['data_criacao'] != null 
          ? DateTime.parse(json['data_criacao'] as String)
          : DateTime.now(),
      dataConclusao: json['data_conclusao'] != null
          ? DateTime.parse(json['data_conclusao'] as String)
          : null,
      arquivo: json['arquivo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'status': status.value,
    };
  }

  Task copyWith({
    String? id,
    String? titulo,
    String? descricao,
    TaskStatus? status,
    DateTime? dataCriacao,
    DateTime? dataConclusao,
    String? arquivo,
  }) {
    return Task(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      arquivo: arquivo ?? this.arquivo,
    );
  }
}

enum TaskStatus {
  pendente('pendente'),
  emAndamento('em_andamento'),
  concluida('concluida');

  final String value;

  const TaskStatus(this.value);

  static TaskStatus fromString(String? value) {
    if (value == null) return TaskStatus.pendente;
    
    switch (value) {
      case 'pendente':
        return TaskStatus.pendente;
      case 'em_andamento':
        return TaskStatus.emAndamento;
      case 'concluida':
        return TaskStatus.concluida;
      default:
        return TaskStatus.pendente;
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.pendente:
        return 'Pendente';
      case TaskStatus.emAndamento:
        return 'Em Andamento';
      case TaskStatus.concluida:
        return 'Concluída';
    }
  }
}

