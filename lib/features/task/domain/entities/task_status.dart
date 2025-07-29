enum TaskStatus {
  todo,
  inProgress,
  done;

  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }

  static TaskStatus? fromString(String value) {
    try {
      return TaskStatus.values.firstWhere(
        (e) => e.toString() == 'TaskStatus.${value.toLowerCase().replaceAll(' ', '')}',
      );
    } catch (e) {
      return null;
    }
  }
}
