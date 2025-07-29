import 'package:fpdart/fpdart.dart';
import 'package:task_now/core/errors/failures.dart';


abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, void>> addTask(Task task);
  Future<Either<Failure, void>> updateTask(Task task);
  Future<Either<Failure, void>> deleteTask(String id);
}
