import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient);

  final ApiClient _apiClient;
  String? _token;

  bool get isAuthenticated => _token != null;
  String? get token => _token;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _token = await _apiClient.obtainToken(
      username: username,
      password: password,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    final token = _token;
    if (token == null) return;

    try {
      await _apiClient.logout(token);
    } finally {
      _token = null;
      notifyListeners();
    }
  }

  void clearInvalidToken() {
    if (_token == null) return;
    _token = null;
    notifyListeners();
  }
}
