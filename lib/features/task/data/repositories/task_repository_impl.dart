import 'package:fpdart/fpdart.dart';
import 'package:task_now/core/errors/failures.dart';
import 'package:task_now/features/task/data/datasources/task_local_data_source.dart';
import 'package:task_now/features/task/domain/entities/task.dart' show MainTask;
import 'package:task_now/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<MainTask>>> getTasks() async {
    try {
      final tasks = await localDataSource.getTasks();
      return right(tasks);
    } catch (e) {
      return left(const CacheFailure(message: 'Failed to load tasks'));
    }
  }

  @override
  Future<Either<Failure, void>> addTask(MainTask task) async {
    try {
      await localDataSource.addTask(task);
      return right(null);
    } catch (e) {
      return left(const CacheFailure(message: 'Failed to add task'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(MainTask task) async {
    try {
      await localDataSource.updateTask(task);
      return right(null);
    } catch (e) {
      return left(const CacheFailure(message: 'Failed to update task'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await localDataSource.deleteTask(id);
      return right(null);
    } catch (e) {
      return left(const CacheFailure(message: 'Failed to delete task'));
    }
  }
}
