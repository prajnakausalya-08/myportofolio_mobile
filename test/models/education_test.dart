import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/education.dart';

void main() {
  const response = <String, dynamic>{
    'id': 7,
    'school': 'Universitas Indonesia',
    'start_year': 2022,
    'end_year': 2026,
    'curriculum': 'Ilmu Komputer',
    'description': 'Program sarjana.',
    'star_count': 3,
    'is_starred': true,
    'starred_by_names': 'editor, owner, student',
  };

  test('Education membaca nama field yang diberikan backend Django', () {
    final education = Education.fromJson(response);

    expect(education.id, 7);
    expect(education.school, 'Universitas Indonesia');
    expect(education.startYear, 2022);
    expect(education.endYear, 2026);
    expect(education.curriculum, 'Ilmu Komputer');
    expect(education.description, 'Program sarjana.');
    expect(education.starCount, 3);
    expect(education.isStarred, isTrue);
    expect(education.starredByNames, 'editor, owner, student');
  });

  test('toJson memakai snake_case sesuai serializer', () {
    final education = Education.fromJson(response);

    expect(education.toJson(), response);
  });

  test('payload create hanya mengirim field yang dapat ditulis', () {
    const education = Education(
      id: 0,
      school: 'SMA',
      startYear: 2019,
      endYear: 2022,
      curriculum: 'Merdeka',
      description: 'Pendidikan menengah.',
    );

    expect(education.toCreateJson(), {
      'school': 'SMA',
      'start_year': 2019,
      'end_year': 2022,
      'curriculum': 'Merdeka',
      'description': 'Pendidikan menengah.',
    });
  });
}
