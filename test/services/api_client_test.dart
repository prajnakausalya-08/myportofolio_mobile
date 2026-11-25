import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

const _educationJson = <String, dynamic>{
  'id': 1,
  'school': 'Universitas Indonesia',
  'start_year': 2022,
  'end_year': 2026,
  'curriculum': 'Ilmu Komputer',
  'description': 'Program sarjana.',
  'star_count': 1,
  'is_starred': false,
  'starred_by_names': 'student',
};

void main() {
  test('GET daftar publik memakai endpoint Education tanpa token', () async {
    late http.Request seenRequest;
    final client = ApiClient(
      baseUrl: 'https://api.example.test/',
      client: MockClient((request) async {
        seenRequest = request;
        return http.Response(jsonEncode([_educationJson]), 200);
      }),
    );
    addTearDown(client.close);

    final educations = await client.getEducations();

    expect(
      seenRequest.url.toString(),
      'https://api.example.test/api/v1/education/',
    );
    expect(seenRequest.headers.containsKey('Authorization'), isFalse);
    expect(educations.single.school, 'Universitas Indonesia');
  });

  test('GET detail menggunakan id numerik dari backend', () async {
    late Uri requestedUri;
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(jsonEncode(_educationJson), 200);
      }),
    );
    addTearDown(client.close);

    final education = await client.getEducation(1);

    expect(requestedUri.path, '/api/v1/education/1/');
    expect(education.id, 1);
  });

  test('POST mengirim field writable dan header Token', () async {
    late http.Request seenRequest;
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        seenRequest = request;
        return http.Response(jsonEncode(_educationJson), 201);
      }),
    );
    addTearDown(client.close);

    final saved = await client.createEducation(
      token: 'secret-token',
      school: 'Universitas Indonesia',
      startYear: 2022,
      endYear: 2026,
      curriculum: 'Ilmu Komputer',
      description: 'Program sarjana.',
    );
    final payload = jsonDecode(seenRequest.body) as Map<String, dynamic>;

    expect(seenRequest.url.path, '/api/v1/education/');
    expect(seenRequest.headers['Authorization'], 'Token secret-token');
    expect(payload.keys.toSet(), {
      'school',
      'start_year',
      'end_year',
      'curriculum',
      'description',
    });
    expect(saved.id, 1);
  });

  test('login mengirim username dan password tanpa header token', () async {
    late http.Request seenRequest;
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        seenRequest = request;
        return http.Response(jsonEncode({'token': 'new-token'}), 200);
      }),
    );
    addTearDown(client.close);

    final token = await client.obtainToken(
      username: 'owner',
      password: 'password',
    );
    final payload = jsonDecode(seenRequest.body) as Map<String, dynamic>;

    expect(seenRequest.url.path, '/api/v1/auth/token/');
    expect(seenRequest.headers.containsKey('Authorization'), isFalse);
    expect(payload, {'username': 'owner', 'password': 'password'});
    expect(token, 'new-token');
  });

  test('logout mengirim token pada endpoint logout', () async {
    late http.Request seenRequest;
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        seenRequest = request;
        return http.Response('', 204);
      }),
    );
    addTearDown(client.close);

    await client.logout('existing-token');

    expect(seenRequest.url.path, '/api/v1/auth/logout/');
    expect(seenRequest.headers['Authorization'], 'Token existing-token');
  });

  test(
    'response error menjadi ApiException tanpa menampilkan HTML server',
    () async {
      final client = ApiClient(
        baseUrl: 'https://api.example.test',
        client: MockClient(
          (_) async => http.Response('<html>private</html>', 500),
        ),
      );
      addTearDown(client.close);

      await expectLater(
        client.getEducations(),
        throwsA(
          isA<ApiException>()
              .having((error) => error.statusCode, 'statusCode', 500)
              .having(
                (error) => error.message,
                'message',
                contains('HTTP 500'),
              ),
        ),
      );
    },
  );

  test('response sukses dengan JSON rusak menjadi ApiException', () async {
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((_) async => http.Response('{invalid', 200)),
    );
    addTearDown(client.close);

    await expectLater(
      client.getEducations(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Response server bukan JSON yang valid.',
        ),
      ),
    );
  });

  test(
    'draft Education dapat dikirim dengan field serializer backend',
    () async {
      final draft = Education(
        id: 0,
        school: 'SMA',
        startYear: 2019,
        endYear: 2022,
        curriculum: 'Merdeka',
        description: 'Pendidikan menengah.',
      );

      expect(draft.toCreateJson().containsKey('id'), isFalse);
      expect(draft.toCreateJson().containsKey('star_count'), isFalse);
    },
  );
}
