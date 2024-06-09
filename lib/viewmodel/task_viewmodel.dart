import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/task_model.dart';
import '../services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  int _currentPage = 0;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks({int limit = 10, int skip = 0}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (skip == 0) {
        _tasks.clear();
        _currentPage = 0;
      }
      _tasks.addAll(await loadTasksLocally());
      if (_tasks.isEmpty) {
        final List<Task> newTasks = await _taskService.fetchTasks(limit, skip);
        _tasks.addAll(newTasks);
        await saveTasksLocally(_tasks);
      }
    } catch (e) {
      print('Error in fetchTasks ViewModel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    final newTask = Task(todo: title, completed: false, userId: 5);

    try {
      final createdTask = await _taskService.addTask(newTask);
      print('Task added with ID: ${createdTask.id}');
      _tasks.insert(0, createdTask);
      await saveTasksLocally(_tasks);
      notifyListeners();
    } catch (e) {
      print('Error in addTask ViewModel: $e');
    }
  }

  Future<void> editTask(Task task) async {
    try {
      print('Editing task with ID: ${task.id}');
      final updatedTask = await _taskService.editTask(task);
      print('Task updated with ID: ${updatedTask.id}');
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        await saveTasksLocally(_tasks);
        notifyListeners();
      } else {
        print('Task with ID: ${task.id} not found in the local list');
      }
    } catch (e) {
      print('Error in editTask ViewModel: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      print('Deleting task with ID: $id');
      await _taskService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      print('Task deleted successfully');
      await saveTasksLocally(_tasks);
      notifyListeners();
    } catch (e) {
      print('Error in deleteTask ViewModel: $e');
    }
  }

  Future<void> saveTasksLocally(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson =
        tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskListJson);
  }

  Future<List<Task>> loadTasksLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = prefs.getStringList('tasks');
    if (taskListJson != null) {
      return taskListJson
          .map((json) => Task.fromJson(jsonDecode(json)))
          .toList();
    }
    return [];
  }
}
