import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../model/task_model.dart';

class TaskListScreen extends StatefulWidget {
  TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration()).then((value) {
      Provider.of<TaskViewModel>(context, listen: false).fetchTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _taskBar(context),
      body: Consumer<TaskViewModel>(
        builder: (context, taskViewModel, child) {
          if (taskViewModel.isLoading || taskViewModel.tasks.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _taskScreen(taskViewModel, context);
          }
        },
      ),
    );
  }

  Column _taskScreen(TaskViewModel taskViewModel, BuildContext context) {
    return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: const InputDecoration(labelText: 'New Task'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        if (_taskController.text.isNotEmpty) {
                          try {
                            await taskViewModel.addTask(_taskController.text);
                            _taskController.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to add task')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: taskViewModel.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskViewModel.tasks[index];
                    return ListTile(
                      title: Text(task.todo),
                      subtitle: Text(task.completed ? 'Completed' : 'Incomplete'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await taskViewModel.deleteTask(task.id!);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to delete task')),
                            );
                          }
                        },
                      ),
                      onTap: () async {
                        final editedTask = await _showEditDialog(context, task);
                        if (editedTask != null) {
                          try {
                            await taskViewModel.editTask(editedTask);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to edit task')),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }

  AppBar _taskBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Tasks'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Provider.of<AuthViewModel>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ],
    );
  }

  Future<Task?> _showEditDialog(BuildContext context, Task task) async {
    final TextEditingController editController = TextEditingController(text: task.todo);
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      return Task(
        id: task.id,
        todo: editController.text,
        completed: task.completed,
        userId: task.userId,
      );
    }
    return null;
  }
}