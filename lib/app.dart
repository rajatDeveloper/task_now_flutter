import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_now/core/theme/app_theme.dart';
import 'package:task_now/features/task/presentation/pages/task_list_page.dart';
import 'package:task_now/features/task/presentation/bloc/task_bloc.dart';

class TaskNowApp extends StatelessWidget {
  const TaskNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>()..add(LoadTasks()),
        ),
      ],
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
