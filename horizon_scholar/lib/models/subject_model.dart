import 'package:hive/hive.dart';

part 'subject_model.g.dart';

@HiveType(typeId: 4) // keep typeId exactly the same
class SubjectModel extends HiveObject {
  @HiveField(0)
  int semester;

  @HiveField(1)
  String name;

  @HiveField(2)
  double credits;

  @HiveField(3)
  String grade; // "O", "A+", "A", etc.

  @HiveField(4, defaultValue: 'None')  // <--- default for old stuff
  String code;                     // <--- now NON-nullable

  SubjectModel({
    required this.semester,
    required this.name,
    required this.credits,
    this.grade = '',
    required this.code,           // <--- required
  });
}
