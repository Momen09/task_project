import 'package:dio/dio.dart';
import '../consts/consts.dart';
import '../model/task_model.dart';
import 'errors/dio_exceptions.dart';

class TaskService {
  final Dio _dio = Dio();

  Future<List<Task>> fetchTasks(int limit, int skip) async {
    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'limit': limit,
        'skip': skip,
      });
      List<dynamic> data = response.data['todos'];
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw ApiException.fromDioError(e as DioException);
    }
  }

  Future<Task> addTask(Task task) async {
    try {
      final response = await _dio.post('$baseUrl/add', data: task.toJson());
      return Task.fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioError(e as DioException);
    }
  }

  Future<Task> editTask(Task task) async {
    try {
      final response = await _dio.put('$baseUrl/${task.id}', data: task.toJson());
      return Task.fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioError(e as DioException);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('$baseUrl/$id');
    } catch (e) {
      print(ApiException.fromDioError(e as DioException));
      throw ApiException.fromDioError(e as DioException);

    }
  }

  Future<Task> updateTaskCompletedStatus(int id, bool completed) async {
    try {
      final response = await _dio.put('$baseUrl/$id', data: {
        'completed': completed,
      });
      return Task.fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioError(e as DioException);
    }
  }
}
