import 'package:fpdart/fpdart.dart';
import 'package:task_now/core/errors/failures.dart';
import 'package:task_now/core/usecase/usecase.dart';
import 'package:task_now/features/task/domain/repositories/task_repository.dart';

class DeleteTask implements UseCase<void, String> {
  final TaskRepository repository;

  const DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      await repository.deleteTask(id);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
