import 'package:fpdart/fpdart.dart' as fp;
import 'package:task_now/core/errors/failures.dart';
import 'package:task_now/core/usecase/usecase.dart';
import 'package:task_now/features/task/domain/entities/task.dart' show MainTask;
import 'package:task_now/features/task/domain/repositories/task_repository.dart';

class GetTasks implements UseCase<List<MainTask>, NoParams> {
  final TaskRepository repository;

  const GetTasks(this.repository);

  @override
  Future<fp.Either<Failure, List<MainTask>>> call(NoParams params) async {
    return await repository.getTasks();
  }
}
