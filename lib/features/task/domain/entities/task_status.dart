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
      // Handle both enum name and display name
      final normalizedValue = value.toLowerCase().replaceAll(' ', '');
      return TaskStatus.values.firstWhere(
        (e) => e.toString().toLowerCase() == 'taskstatus.$normalizedValue' ||
              e.displayName.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
