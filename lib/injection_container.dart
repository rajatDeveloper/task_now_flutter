import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_now/features/task/data/datasources/task_local_data_source.dart';
import 'package:task_now/features/task/data/models/task_model.dart';
import 'package:task_now/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_now/features/task/domain/repositories/task_repository.dart';
import 'package:task_now/features/task/domain/usecases/add_task.dart';
import 'package:task_now/features/task/domain/usecases/delete_task.dart';
import 'package:task_now/features/task/domain/usecases/get_tasks.dart';
import 'package:task_now/features/task/domain/usecases/update_task.dart';
import 'package:task_now/features/task/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());

  // Data sources
  final taskBox = await Hive.openBox<TaskModel>('tasks');
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(box: taskBox),
  );

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  // Bloc
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      addTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );
}
