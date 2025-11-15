import 'package:hive/hive.dart';
part 'cgpa_model.g.dart'; // Required for Hive type adapter

@HiveType(typeId: 0)
class CgpaModel {
  @HiveField(0)
  double cgpa;

  @HiveField(1)
  int currentSem;

  @HiveField(2)
  List<List<double>> marks;

  CgpaModel({
    required this.cgpa,
    required this.currentSem,
    required this.marks,
  });
}
