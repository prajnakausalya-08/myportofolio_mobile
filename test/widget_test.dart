import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Home menampilkan identitas dan membuka form', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('2506657213'), findsOneWidget);
    expect(find.text('Prajna Kausalya Damdami'), findsOneWidget);
    expect(find.text('PBP F'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
    expect(find.text('Nama Proyek'), findsWidgets);
    expect(find.text('Deskripsi Proyek'), findsWidgets);
    expect(find.text('Kategori Proyek'), findsOneWidget);
    expect(find.text('Teknologi yang Digunakan'), findsOneWidget);
    expect(find.text('Tautan Proyek'), findsOneWidget);
  });

  testWidgets('Drawer menavigasi ke form dan kembali ke Home', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('My Portfolio'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('2506657213'), findsOneWidget);
  });

  testWidgets('Validasi, dialog dan reset form', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '   ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Proyek Flutter');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Deskripsi contoh',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Flutter, Django');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'https://example.com',
    );
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: Proyek Flutter'), findsOneWidget);
    expect(find.text('Deskripsi: Deskripsi contoh'), findsOneWidget);
    expect(find.text('Kategori: Mobile Development'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Django'), findsOneWidget);
    expect(find.text('Tautan: https://example.com'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.controller.text, isEmpty);
    }
    expect(find.text('Web Development'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Proyek baru');
    await tester.enterText(find.byType(TextFormField).at(1), 'Deskripsi baru');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
  });

  testWidgets('Tambah Pendidikan dapat dibuka dari kartu dan kembali', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Tambah Pendidikan'), findsOneWidget);

    await tester.tap(find.text('Tambah Pendidikan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama Institusi / Sekolah'), findsOneWidget);
    expect(find.text('Deskripsi Pendidikan'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('2506657213'), findsOneWidget);
  });

  testWidgets('Drawer membuka Education dan Home kembali ke halaman utama', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Add Education'), findsOneWidget);

    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Pendidikan'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('2506657213'), findsOneWidget);
  });

  testWidgets(
    'Validasi Education menolak nilai tidak valid dan merangkum data',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Tambah Pendidikan'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(5));

      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();
      expect(find.text('Nama institusi wajib diisi.'), findsOneWidget);
      expect(find.text('Tahun Mulai wajib diisi.'), findsOneWidget);
      expect(find.text('Tahun Selesai wajib diisi.'), findsOneWidget);
      expect(find.text('Kurikulum wajib diisi.'), findsOneWidget);
      expect(find.text('Deskripsi pendidikan wajib diisi.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);

      await tester.enterText(fields.at(0), '   ');
      await tester.enterText(fields.at(1), 'abc');
      await tester.enterText(fields.at(2), '2022');
      await tester.enterText(fields.at(3), '   ');
      await tester.enterText(fields.at(4), '   ');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();
      expect(find.text('Nama institusi wajib diisi.'), findsOneWidget);
      expect(
        find.text('Tahun Mulai harus berupa bilangan bulat.'),
        findsOneWidget,
      );
      expect(find.text('Kurikulum wajib diisi.'), findsOneWidget);
      expect(find.text('Deskripsi pendidikan wajib diisi.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);

      await tester.enterText(fields.at(0), 'Universitas Indonesia');
      await tester.enterText(fields.at(1), '2025');
      await tester.enterText(fields.at(2), '2022');
      await tester.enterText(fields.at(3), 'Ilmu Komputer');
      await tester.enterText(
        fields.at(4),
        'Belajar dan mengembangkan teknologi.',
      );
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();
      expect(
        find.text('Tahun Mulai tidak boleh melebihi Tahun Selesai.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);

      await tester.enterText(fields.at(1), '2020');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      expect(
        find.descendant(
          of: dialog,
          matching: find.text('Ringkasan Pendidikan'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: dialog,
          matching: find.text('Universitas Indonesia'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.text('2020')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.text('2022')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.text('Ilmu Komputer')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: dialog,
          matching: find.text('Belajar dan mengembangkan teknologi.'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Tambah Pendidikan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
