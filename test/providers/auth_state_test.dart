import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/providers/auth_state.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  test('login menyimpan token dalam state dan logout mencabutnya', () async {
    var logoutCalled = false;
    final apiClient = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(jsonEncode({'token': 'memory-token'}), 200);
        }
        if (request.url.path == '/api/v1/auth/logout/') {
          logoutCalled = true;
          expect(request.headers['Authorization'], 'Token memory-token');
          return http.Response('', 204);
        }
        return http.Response('Not found', 404);
      }),
    );
    addTearDown(apiClient.close);
    final authState = AuthState(apiClient);
    addTearDown(authState.dispose);

    await authState.login(username: 'owner', password: 'password');
    expect(authState.isAuthenticated, isTrue);
    expect(authState.token, 'memory-token');

    await authState.logout();
    expect(logoutCalled, isTrue);
    expect(authState.isAuthenticated, isFalse);
    expect(authState.token, isNull);
  });

  test('token lokal dibersihkan bila backend menolak token', () async {
    final apiClient = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(jsonEncode({'token': 'memory-token'}), 200);
        }
        return http.Response(jsonEncode({'detail': 'Invalid token.'}), 401);
      }),
    );
    addTearDown(apiClient.close);
    final authState = AuthState(apiClient);
    addTearDown(authState.dispose);

    await authState.login(username: 'owner', password: 'password');
    await expectLater(authState.logout(), throwsA(isA<ApiException>()));
    expect(authState.isAuthenticated, isFalse);
  });
}
