import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_now/features/task/domain/entities/task.dart';
import 'package:task_now/features/task/domain/entities/task_status.dart';
import 'package:task_now/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_now/features/task/presentation/bloc/task_event.dart';
import 'package:task_now/features/task/presentation/bloc/task_state.dart';
import 'package:task_now/features/task/presentation/widgets/empty_state.dart';
import 'package:task_now/features/task/presentation/widgets/loading_indicator.dart';
import 'package:task_now/features/task/presentation/widgets/task_card.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTaskDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TaskBloc>().add(const LoadTasks()),
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const CustomLoadingIndicator(message: 'Loading tasks...');
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;
            
            if (tasks.isEmpty) {
              return EmptyState(
                message: 'No tasks yet!\nTap the + button to add a new task.',
                actionText: 'Add Task',
                onActionPressed: _showAddTaskDialog,
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(const LoadTasks());
              },
              child: ListView.builder(
                itemCount: tasks.length,
                padding: const EdgeInsets.only(bottom: 80),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () => _showTaskDetails(task),
                    onStatusChanged: (value) {
                      // Dispatch the ToggleTaskStatus event
                      context.read<TaskBloc>().add(ToggleTaskStatus(task));
                    },
                    onDelete: () => _confirmDeleteTask(task),
                  );
                },
              ),
            );
          } else if (state is TaskError) {
            return EmptyState(
              message: 'Failed to load tasks.\n${state.message}',
              actionText: 'Retry',
              onActionPressed: () {
                context.read<TaskBloc>().add(const LoadTasks());
              },
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 1));
    TaskStatus selectedStatus = TaskStatus.todo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Due Date'),
                      subtitle: Text(
                        '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() => dueDate = date);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('Status'),
                    DropdownButtonFormField<TaskStatus>(
                      value: selectedStatus,
                      items: TaskStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            status.toString().split('.').last.toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedStatus = value);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }

                    final newTask = MainTask(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      dueDate: dueDate,
                      status: selectedStatus,
                    );

                    context.read<TaskBloc>().add(AddTaskEvent(newTask));
                    Navigator.pop(context);
                  },
                  child: const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTaskDetails(MainTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Task Details',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Divider(),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.title),
              title: const Text('Title'),
              subtitle: Text(task.title),
            ),
            if (task.description.isNotEmpty) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Description'),
                subtitle: Text(task.description),
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Due Date'),
              subtitle: Text(
                '${task.dueDate.year}-${task.dueDate.month.toString().padLeft(2, '0')}-${task.dueDate.day.toString().padLeft(2, '0')}',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Status'),
              subtitle: Text(
                task.status.toString().split('.').last.toUpperCase(),
              ),
              trailing: PopupMenuButton<TaskStatus>(
                onSelected: (status) {
                  final updatedTask = task.copyWith(status: status);
                  context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task status updated')),
                  );
                },
                itemBuilder: (context) => TaskStatus.values.map((status) {
                  return PopupMenuItem(
                    value: status,
                    child: Text(status.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                child: const Text('Change Status'),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Task'),
              onTap: () {
                Navigator.pop(context);
                _showEditTaskDialog(task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Task', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteTask(task);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(MainTask task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    DateTime dueDate = task.dueDate;
    TaskStatus selectedStatus = task.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Due Date'),
                      subtitle: Text(
                        '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() => dueDate = date);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('Status'),
                    DropdownButtonFormField<TaskStatus>(
                      value: selectedStatus,
                      items: TaskStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(
                            status.toString().split('.').last.toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedStatus = value);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }

                    final updatedTask = task.copyWith(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      dueDate: dueDate,
                      status: selectedStatus,
                      updatedAt: DateTime.now(),
                    );

                    context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task updated')),
                    );
                  },
                  child: const Text('UPDATE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteTask(MainTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}