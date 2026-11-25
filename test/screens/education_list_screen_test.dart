import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('daftar Education menampilkan data dari backend', (tester) async {
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        expect(request.url.path, '/api/v1/education/');
        expect(request.headers.containsKey('Authorization'), isFalse);
        return http.Response(
          jsonEncode([
            {
              'id': 3,
              'school': 'Universitas Indonesia',
              'start_year': 2022,
              'end_year': 2026,
              'curriculum': 'Ilmu Komputer',
              'description': 'Program sarjana.',
              'star_count': 2,
              'is_starred': false,
              'starred_by_names': 'student, owner',
            },
          ]),
          200,
        );
      }),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Lihat Pendidikan'));
    await tester.pumpAndSettle();

    expect(find.text('Pendidikan'), findsOneWidget);
    expect(find.text('Universitas Indonesia'), findsOneWidget);
    expect(find.text('2022 – 2026'), findsOneWidget);
    expect(find.text('Kurikulum: Ilmu Komputer'), findsOneWidget);
    expect(find.text('Program sarjana.'), findsOneWidget);
    expect(find.text('2 star'), findsOneWidget);
  });

  testWidgets('empty state ditampilkan ketika backend mengirim array kosong', (
    tester,
  ) async {
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Lihat Pendidikan'));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada data pendidikan.'), findsOneWidget);
  });

  testWidgets('submit Education meminta login lalu mengirim token', (
    tester,
  ) async {
    var createRequestReceived = false;
    final client = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(jsonEncode({'token': 'form-token'}), 200);
        }
        if (request.url.path == '/api/v1/education/' &&
            request.method == 'POST') {
          createRequestReceived = true;
          expect(request.headers['Authorization'], 'Token form-token');
          expect(jsonDecode(request.body), {
            'school': 'Universitas Indonesia',
            'start_year': 2022,
            'end_year': 2026,
            'curriculum': 'Ilmu Komputer',
            'description': 'Program sarjana.',
          });
          return http.Response(
            jsonEncode({
              'id': 9,
              'school': 'Universitas Indonesia',
              'start_year': 2022,
              'end_year': 2026,
              'curriculum': 'Ilmu Komputer',
              'description': 'Program sarjana.',
              'star_count': 0,
              'is_starred': false,
              'starred_by_names': '',
            }),
            201,
          );
        }
        return http.Response('Not found', 404);
      }),
    );
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MyApp(apiClient: client));
    await tester.tap(find.text('Tambah Pendidikan').first);
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Universitas Indonesia');
    await tester.enterText(fields.at(1), '2022');
    await tester.enterText(fields.at(2), '2026');
    await tester.enterText(fields.at(3), 'Ilmu Komputer');
    await tester.enterText(fields.at(4), 'Program sarjana.');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kirim ke server'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('login-username')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('login-username')),
      'portfolio-owner',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password')),
      'test-password',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(createRequestReceived, isTrue);
    expect(find.text('2506657213'), findsOneWidget);
  });
}
