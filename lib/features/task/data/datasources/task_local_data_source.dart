import 'package:hive/hive.dart';
import 'package:task_now/features/task/data/models/task_model.dart';
import 'package:task_now/features/task/domain/entities/task.dart' show MainTask;

abstract class TaskLocalDataSource {
  Future<List<MainTask>> getTasks();
  Future<void> addTask(MainTask task);
  Future<void> updateTask(MainTask task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskModel> box;

  TaskLocalDataSourceImpl({required this.box});

  @override
  Future<List<MainTask>> getTasks() async {
    return box.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addTask(MainTask task) async {
    await box.put(task.id, TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(MainTask task) async {
    await box.put(task.id, TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await box.delete(id);
  }
}
