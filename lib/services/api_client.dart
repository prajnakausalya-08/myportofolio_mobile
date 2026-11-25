import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/education.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = _normalizeBaseUrl(baseUrl ?? apiBaseUrl);

  final http.Client _client;
  final String _baseUrl;
  static const Duration _timeout = Duration(seconds: 20);

  static String _normalizeBaseUrl(String value) =>
      value.replaceFirst(RegExp(r'/+$'), '');

  Uri _uri(String path) => Uri.parse('$_baseUrl/api/v1/$path');

  Future<List<Education>> getEducations({String? school, String? token}) async {
    final query = <String, String>{};
    if (school != null && school.trim().isNotEmpty) {
      query['school'] = school.trim();
    }

    final educationUri = _uri('education/');
    final uri = query.isEmpty
        ? educationUri
        : educationUri.replace(queryParameters: query);
    final response = await _send(
      () => _client.get(
        uri,
        headers: token == null ? null : _authorizationHeaders(token),
      ),
    );
    final decoded = _decode(response);
    if (decoded is! List) {
      throw const ApiException(
        'Format daftar Education dari server tidak valid.',
      );
    }

    try {
      return decoded
          .map(
            (item) =>
                Education.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false);
    } on TypeError {
      throw const ApiException(
        'Data Education dari server tidak dapat dibaca.',
      );
    } on FormatException {
      throw const ApiException(
        'Data Education dari server tidak dapat dibaca.',
      );
    }
  }

  Future<Education> getEducation(int id, {String? token}) async {
    final response = await _send(
      () => _client.get(
        _uri('education/$id/'),
        headers: token == null ? null : _authorizationHeaders(token),
      ),
    );
    final decoded = _decode(response);
    if (decoded is! Map) {
      throw const ApiException(
        'Format detail Education dari server tidak valid.',
      );
    }

    try {
      return Education.fromJson(Map<String, dynamic>.from(decoded));
    } on TypeError {
      throw const ApiException(
        'Data Education dari server tidak dapat dibaca.',
      );
    } on FormatException {
      throw const ApiException(
        'Data Education dari server tidak dapat dibaca.',
      );
    }
  }

  Future<Education> createEducation({
    required String token,
    required String school,
    required int startYear,
    required int endYear,
    required String curriculum,
    required String description,
  }) async {
    final response = await _send(
      () => _client.post(
        _uri('education/'),
        headers: _authorizedJsonHeaders(token),
        body: jsonEncode({
          'school': school,
          'start_year': startYear,
          'end_year': endYear,
          'curriculum': curriculum,
          'description': description,
        }),
      ),
    );
    final decoded = _decode(response);
    if (decoded is! Map) {
      throw const ApiException(
        'Format Education setelah disimpan tidak valid.',
      );
    }

    try {
      return Education.fromJson(Map<String, dynamic>.from(decoded));
    } on TypeError {
      throw const ApiException(
        'Data Education dari server tidak dapat dibaca.',
      );
    } on FormatException {
      throw const ApiException(
        'Data Education dari server tidak dapat dibaca.',
      );
    }
  }

  Future<String> obtainToken({
    required String username,
    required String password,
  }) async {
    final response = await _send(
      () => _client.post(
        _uri('auth/token/'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      ),
    );
    final decoded = _decode(response);
    if (decoded is! Map || decoded['token'] is! String) {
      throw const ApiException('Login tidak menghasilkan token yang valid.');
    }
    return decoded['token'] as String;
  }

  Future<void> logout(String token) async {
    await _send(
      () => _client.post(
        _uri('auth/logout/'),
        headers: _authorizationHeaders(token),
      ),
    );
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(_timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _messageFromResponse(response),
          statusCode: response.statusCode,
        );
      }
      return response;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('Request ke server melewati batas waktu.');
    } on http.ClientException {
      throw const ApiException('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw const ApiException('Response server bukan JSON yang valid.');
    }
  }

  dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const ApiException('Response server bukan JSON yang valid.');
    }
  }

  String _messageFromResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map) {
        final detail = body['detail'];
        if (detail is String && detail.isNotEmpty) return detail;
        final messages = body.entries.expand((entry) {
          final value = entry.value;
          if (value is List) {
            return value.map((message) => '${entry.key}: $message');
          }
          return ['${entry.key}: $value'];
        }).toList();
        if (messages.isNotEmpty) return messages.join(' ');
      }
    } on FormatException {
      // Avoid showing raw HTML or server diagnostics to the user.
    }
    return 'Permintaan gagal (HTTP ${response.statusCode}).';
  }

  Map<String, String> _authorizationHeaders(String token) => {
    'Authorization': 'Token $token',
  };

  Map<String, String> _authorizedJsonHeaders(String token) => {
    ..._authorizationHeaders(token),
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void close() => _client.close();
}
