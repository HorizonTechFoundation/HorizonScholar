import 'package:hive/hive.dart';
part 'document_model.g.dart';

@HiveType(typeId: 1)
class DocumentModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String path;

  @HiveField(2)
  String type;

  @HiveField(3)
  String isFav;

  DocumentModel({
    required this.title,
    required this.path,
    required this.type,
    required this.isFav,
  });
}
