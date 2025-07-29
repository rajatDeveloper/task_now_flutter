import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:task_now/features/task/domain/entities/task.dart' show MainTask;

@immutable
sealed class TaskEvent extends Equatable {
  const TaskEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class AddTaskEvent extends TaskEvent {
  final MainTask task;
  
  const AddTaskEvent(this.task);
  
  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final MainTask task;
  
  const UpdateTaskEvent(this.task);
  
  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  
  const DeleteTaskEvent(this.taskId);
  
  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskStatus extends TaskEvent {
  final MainTask task;
  
  const ToggleTaskStatus(this.task);
  
  @override
  List<Object?> get props => [task];
}

class FilterTasks extends TaskEvent {
  final String filter;
  
  const FilterTasks(this.filter);
  
  @override
  List<Object?> get props => [filter];
}

class ToggleTheme extends TaskEvent {
  final bool isDarkMode;
  
  const ToggleTheme(this.isDarkMode);
  
  @override
  List<Object?> get props => [isDarkMode];
}
