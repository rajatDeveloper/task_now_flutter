import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class Params<T> {
  final T data;
  const Params(this.data);
}
