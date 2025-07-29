import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_now/core/theme/app_theme.dart';
import 'package:task_now/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_now/features/task/presentation/bloc/task_event.dart';
import 'package:task_now/features/task/presentation/pages/task_list_page.dart';

class TaskNowApp extends StatelessWidget {
  const TaskNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => GetIt.I<TaskBloc>()..add(const LoadTasks()),
      child: MaterialApp(
        title: 'Task Now',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const TaskListPage(),
      ),
    );
  }
}
