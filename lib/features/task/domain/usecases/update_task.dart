import 'package:fpdart/fpdart.dart';
import 'package:task_now/core/errors/failures.dart';
import 'package:task_now/core/usecase/usecase.dart';
import 'package:task_now/features/task/domain/entities/task.dart' show MainTask;
import 'package:task_now/features/task/domain/repositories/task_repository.dart';

class UpdateTask implements UseCase<void, MainTask> {
  final TaskRepository repository;

  const UpdateTask(this.repository);

  @override
  Future<Either<Failure, void>> call(MainTask task) async {
    try {
      await repository.updateTask(task);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
