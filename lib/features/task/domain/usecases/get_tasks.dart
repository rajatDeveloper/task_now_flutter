import 'package:fpdart/fpdart.dart' as fp;
import 'package:task_now/core/errors/failures.dart';
import 'package:task_now/core/usecase/usecase.dart';
import 'package:task_now/features/task/domain/entities/task.dart' ;
import 'package:task_now/features/task/domain/repositories/task_repository.dart';

class GetTasks implements UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  const GetTasks(this.repository);

  @override
  Future<fp.Either<Failure, List<Task>>> call(NoParams params) async {
    try {
      final tasks = await repository.getTasks();
      return fp.Right(tasks);
    } on Failure catch (e) {
      return  fp.Left(e);
    }
  }
}
