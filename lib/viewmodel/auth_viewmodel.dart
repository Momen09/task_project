import 'package:flutter/foundation.dart';
import 'package:task1/services/auth_service.dart';

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
      final authService = AuthService();
      final response = await authService.login(username, password);

      if (response.statusCode == 200) {
        _token = response.data['token'];
        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      // Handle errors
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
