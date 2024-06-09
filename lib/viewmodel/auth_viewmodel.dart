import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:task1/consts/consts.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await Dio().post(authUrl, data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        _token = response.data['token'];
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _token = null;
    notifyListeners();
  }
}
