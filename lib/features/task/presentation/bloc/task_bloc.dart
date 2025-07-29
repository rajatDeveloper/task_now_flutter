import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_now/features/task/domain/entities/task_status.dart';
import 'package:task_now/core/usecase/usecase.dart';
import 'package:task_now/features/task/domain/usecases/add_task.dart';
import 'package:task_now/features/task/domain/usecases/delete_task.dart';
import 'package:task_now/features/task/domain/usecases/get_tasks.dart';
import 'package:task_now/features/task/domain/usecases/update_task.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
    on<FilterTasks>(_onFilterTasks);
    on<ToggleTheme>(_onToggleTheme);
  }

  FutureOr<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    
    final result = await getTasks(NoParams());
    
    result.fold(
      (failure) => emit(TaskError(failure.toString())),
      (tasks) => emit(
        state is TaskLoaded
            ? (state as TaskLoaded).copyWith(tasks: tasks)
            : TaskLoaded(tasks: tasks),
      ),
    );
  }

  FutureOr<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final result = await addTask(event.task);
      
      result.fold(
        (failure) => emit(TaskError(failure.toString())),
        (_) => add(const LoadTasks()),
      );
    }
  }

  FutureOr<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final result = await updateTask(event.task);
      
      result.fold(
        (failure) => emit(TaskError(failure.toString())),
        (_) => add(const LoadTasks()),
      );
    }
  }

  FutureOr<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final result = await deleteTask(event.taskId);
      
      result.fold(
        (failure) => emit(TaskError(failure.toString())),
        (_) => add(const LoadTasks()),
      );
    }
  }

  FutureOr<void> _onToggleTaskStatus(
    ToggleTaskStatus event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      final task = event.task;
      TaskStatus newStatus;
      
      // Cycle through statuses: todo -> inProgress -> done -> todo
      switch (task.status) {
        case TaskStatus.todo:
          newStatus = TaskStatus.inProgress;
          break;
        case TaskStatus.inProgress:
          newStatus = TaskStatus.done;
          break;
        case TaskStatus.done:
          newStatus = TaskStatus.todo;
          break;
      }
      
      final updatedTask = task.copyWith(status: newStatus);
      final result = await updateTask(updatedTask);
      
      result.fold(
        (failure) => emit(TaskError(failure.toString())),
        (_) => add(const LoadTasks()),
      );
    }
  }

  void _onFilterTasks(
    FilterTasks event,
    Emitter<TaskState> emit,
  ) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(currentState.copyWith(filter: event.filter));
    }
  }

  void _onToggleTheme(
    ToggleTheme event,
    Emitter<TaskState> emit,
  ) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(currentState.copyWith(isDarkMode: event.isDarkMode));
    }
  }
}

