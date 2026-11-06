import 'package:flutter/foundation.dart';

import '../utils/validators.dart';

/// Sesi login dummy. Kredensial yang sah: admin / 123456.
class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _usernameError;
  String? _passwordError;
  String? _credentialsError;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;
  String? get credentialsError => _credentialsError;

  /// Memvalidasi input lalu masuk. Mengembalikan true bila sesi terbentuk.
  Future<bool> login(String username, String password) async {
    if (_isLoading) return false;

    _usernameError = validateUsername(username);
    _passwordError = validatePassword(password);
    _credentialsError = validateCredentials(username, password);

    if (_usernameError != null ||
        _passwordError != null ||
        _credentialsError != null) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(seconds: 1));

    _isLoading = false;
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  /// Menghapus error username saat pengguna mengetik ulang.
  void clearUsernameError() {
    if (_usernameError == null && _credentialsError == null) return;
    _usernameError = null;
    _credentialsError = null;
    notifyListeners();
  }

  /// Menghapus error password saat pengguna mengetik ulang.
  void clearPasswordError() {
    if (_passwordError == null && _credentialsError == null) return;
    _passwordError = null;
    _credentialsError = null;
    notifyListeners();
  }

  /// Mengakhiri sesi dummy.
  void logout() {
    _isLoggedIn = false;
    _isLoading = false;
    _usernameError = null;
    _passwordError = null;
    _credentialsError = null;
    notifyListeners();
  }
}
