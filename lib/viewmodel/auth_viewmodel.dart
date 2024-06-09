import 'package:flutter/foundation.dart';
import 'package:task1/consts/consts.dart';
import 'package:task1/services/auth_service.dart';
import '../model/auth_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _accessToken;
  String? _refreshToken;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  final AuthService _authService = AuthService();

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authResponse = await _authService.login(username, password);
      _accessToken = authResponse.accessToken;
      _refreshToken = authResponse.refreshToken;
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      // Handle login failure
      print('Error in login: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
}
