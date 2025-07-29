import 'package:flutter/material.dart';
import 'package:task_now/features/task/domain/entities/task.dart';
import 'package:task_now/features/task/domain/entities/task_status.dart';

class TaskCard extends StatelessWidget {
  final MainTask task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final ValueChanged<bool?>? onStatusChanged;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onDelete,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDone = task.status == TaskStatus.done;
    final isInProgress = task.status == TaskStatus.inProgress;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Custom status indicator
                  GestureDetector(
                    onTap: () {
                      // Let the parent handle the status change
                      if (onStatusChanged != null) {
                        onStatusChanged!(true);
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isDone 
                            ? Colors.green 
                            : isInProgress 
                                ? Colors.blue 
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isInProgress 
                              ? Colors.blue 
                              : isDone 
                                  ? Colors.green 
                                  : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: isDone 
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : isInProgress 
                              ? const Icon(Icons.hourglass_bottom, size: 16, color: Colors.white)
                              : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration:
                            task.status == TaskStatus.done
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              if (task.description.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: theme.hintColor),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task.dueDate),
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(theme, task.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.status.displayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(ThemeData theme, TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.done:
        return Colors.green;
    }
  }
}
