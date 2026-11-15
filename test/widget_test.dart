import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('Identitas dan menu ditampilkan tanpa error', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(tester.takeException(), isNull);
    expect(find.byType(InfoCard), findsNWidgets(3));
    for (final text in [
      'NPM',
      '2506657213',
      'Name',
      'Prajna Kausalya Damdami',
      'Class',
      'PBP F',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    for (final item in MyHomePage.items) {
      expect(find.text(item.name), findsOneWidget);
      expect(find.byIcon(item.icon), findsOneWidget);
    }
  });

  testWidgets(
    'Setiap kartu menampilkan SnackBar yang sesuai dan mengganti pesan sebelumnya',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      for (final item in MyHomePage.items) {
        await tester.ensureVisible(find.text(item.name));
        await tester.tap(find.text(item.name));
        await tester.pumpAndSettle();
        expect(
          find.text('Kamu telah menekan tombol ${item.name}!'),
          findsOneWidget,
        );
        for (final other in MyHomePage.items.where((other) => other != item)) {
          expect(
            find.text('Kamu telah menekan tombol ${other.name}!'),
            findsNothing,
          );
        }
      }
    },
  );

  testWidgets('Warna dan ikon setiap kartu sesuai data menu', (tester) async {
    await tester.pumpWidget(const MyApp());
    final expected = <String, (IconData, Color)>{
      'Lihat Proyek': (Icons.folder, const Color(0xFF1565C0)),
      'Tambah Proyek': (Icons.add_circle, const Color(0xFF2E7D32)),
      'Logout': (Icons.logout, const Color(0xFFC62828)),
    };
    final colors = <Color>{};
    for (final entry in expected.entries) {
      final card = find.ancestor(
        of: find.text(entry.key),
        matching: find.byType(ItemCard),
      );
      final material = tester.widget<Material>(
        find.descendant(of: card, matching: find.byType(Material)).first,
      );
      expect(material.color, entry.value.$2);
      expect(
        find.descendant(of: card, matching: find.byIcon(entry.value.$1)),
        findsOneWidget,
      );
      colors.add(material.color!);
    }
    expect(colors.length, 3);
  });

  testWidgets('Konten tetap dapat diakses pada layar kecil', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    for (final item in MyHomePage.items) {
      await tester.ensureVisible(find.text(item.name));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(
        find.ancestor(
          of: find.text(item.name),
          matching: find.byType(ItemCard),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Kamu telah menekan tombol ${item.name}!'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }
  });
}
