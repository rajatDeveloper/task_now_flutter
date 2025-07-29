import 'package:fpdart/fpdart.dart';
import 'package:task_now/core/errors/failures.dart';
import 'package:task_now/features/task/domain/entities/task.dart' show MainTask;

abstract class TaskRepository {
  Future<Either<Failure, List<MainTask>>> getTasks();
  Future<Either<Failure, void>> addTask(MainTask task);
  Future<Either<Failure, void>> updateTask(MainTask task);
  Future<Either<Failure, void>> deleteTask(String id);
}
