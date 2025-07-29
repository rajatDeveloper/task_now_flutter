import 'package:equatable/equatable.dart';
import 'package:task_now/features/task/domain/entities/task.dart';

@immutable
sealed class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TaskLoading extends TaskState {
  const TaskLoading();
}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final String filter;
  final bool isDarkMode;
  
  const TaskLoaded({
    required this.tasks,
    this.filter = 'all',
    this.isDarkMode = false,
  });
  
  @override
  List<Object?> get props => [tasks, filter, isDarkMode];
  
  TaskLoaded copyWith({
    List<Task>? tasks,
    String? filter,
    bool? isDarkMode,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

final class TaskError extends TaskState {
  final String message;
  
  const TaskError(this.message);
  
  @override
  List<Object?> get props => [message];
}
