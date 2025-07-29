import 'package:uuid/uuid.dart';

import 'task_status.dart';

class MainTask {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MainTask({
    String? id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.status = TaskStatus.todo,
    DateTime? createdAt,
    this.updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  MainTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MainTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MainTask.fromMap(Map<String, dynamic> map) {
    return MainTask(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      dueDate: DateTime.parse(map['dueDate'] as String),
      status: TaskStatus.fromString(map['status'] as String) ?? TaskStatus.todo,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }
}
