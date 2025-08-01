import 'package:hive/hive.dart';
import 'package:task_now/features/task/domain/entities/task.dart' show MainTask;
import 'package:task_now/features/task/domain/entities/task_status.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromEntity(MainTask task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      // Store the enum value name (e.g., 'todo', 'inProgress', 'done')
      status: task.status.name,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  MainTask toEntity() {
    return MainTask(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      status: TaskStatus.fromString(status) ?? TaskStatus.todo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
