import 'package:fpdart/fpdart.dart';
import 'package:task_now/core/errors/failures.dart';
import 'package:task_now/features/task/data/datasources/task_local_data_source.dart';
import 'package:task_now/features/task/domain/entities/task.dart';
import 'package:task_now/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    try {
      return await localDataSource.getTasks();
    } catch (e) {
      throw const CacheFailure(message: 'Failed to load tasks');
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      await localDataSource.addTask(task);
    } catch (e) {
      throw const CacheFailure(message: 'Failed to add task');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await localDataSource.updateTask(task);
    } catch (e) {
      throw const CacheFailure(message: 'Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await localDataSource.deleteTask(id);
    } catch (e) {
      throw const CacheFailure(message: 'Failed to delete task');
    }
  }
}
