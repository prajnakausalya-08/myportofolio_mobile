import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    required this.id,
    required this.school,
    required this.startYear,
    required this.endYear,
    required this.curriculum,
    required this.description,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  final int id;
  final String school;
  final int startYear;
  final int endYear;
  final String curriculum;
  final String description;
  final int starCount;
  final bool isStarred;
  final String starredByNames;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  Map<String, dynamic> toJson() => _$EducationToJson(this);

  Map<String, dynamic> toCreateJson() => {
    'school': school,
    'start_year': startYear,
    'end_year': endYear,
    'curriculum': curriculum,
    'description': description,
  };
}
