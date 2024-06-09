import 'package:dio/dio.dart';
import 'package:task1/consts/consts.dart';
import 'dart:convert';


class AuthService {
  final Dio _dio = Dio();

  Future<Response> login(String username, String password) async {
    final response = await _dio.post(
      authUrl,
      data: jsonEncode({
        'username': username,
        'password': password,
      }),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to login');
    }
  }
}
