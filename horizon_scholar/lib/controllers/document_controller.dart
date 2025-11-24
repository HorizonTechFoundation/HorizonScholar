import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/course_model.dart';
import '../models/document_model.dart';

class DocumentController extends GetxController {
  static const _boxName = 'documentsBoxV2';

  late Box<DocumentModel> _box;

  final documents = <DocumentModel>[].obs;

  /// Categories shown in the horizontal bar
  final categories = <String>['All', 'Important', 'Course'].obs;

  final selectedCategory = 'All'.obs;
  final showFavoritesOnly = false.obs;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box<DocumentModel>(_boxName);
    _loadDocuments();
    syncFromCourses(); 
  }

  void _loadDocuments() {
    documents.assignAll(_box.values);

    // Build category list from existing docs
    for (final doc in documents) {
      for (final c in doc.categories) {
        if (!categories.contains(c)) {
          categories.add(c);
        }
      }
    }
  }

  List<DocumentModel> get filteredDocuments {
    return documents.where((doc) {
      if (selectedCategory.value != 'All' &&
          !doc.categories.contains(selectedCategory.value)) {
        return false;
      }
      if (showFavoritesOnly.value && !doc.isFav) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> addDocument(DocumentModel doc) async {
    await _box.add(doc);
    documents.add(doc);

    for (final c in doc.categories) {
      if (!categories.contains(c)) {
        categories.add(c);
      }
    }
  }

  Future<void> updateDocument(DocumentModel doc) async {
    await doc.save();
    documents.refresh();

    // Rebuild categories list
    for (final c in doc.categories) {
      if (!categories.contains(c)) {
        categories.add(c);
      }
    }
  }

  Future<void> deleteDocument(DocumentModel doc) async {
    await doc.delete();            // remove from Hive
    documents.remove(doc);         // remove from list
    documents.refresh();
  }


  void toggleFavorite(DocumentModel doc) {
    doc.isFav = !doc.isFav;
    doc.save();
    documents.refresh();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleFavoritesFilter() {
    showFavoritesOnly.value = !showFavoritesOnly.value;
  }

  void addCategory(String category) {
    final trimmed = category.trim();
    if (trimmed.isEmpty) return;
    if (!categories.contains(trimmed)) {
      categories.add(trimmed);
    }
  }
  void syncFromCourses() {
    final courseBox = Hive.box<CourseModel>('courseBox');

    for (final course in courseBox.values) {
      if (course.certificationPath.isEmpty) continue;

      // check if already added
      final exists = documents.any(
        (d) => d.path == course.certificationPath,
      );

      if (!exists) {
        final type = course.certificationPath.split('.').last.toLowerCase();

        final doc = DocumentModel(
          title: course.courseName,
          path: course.certificationPath,
          type: type,
          categories: ["Course"],
          isFav: false,
        );

        _box.add(doc);
        documents.add(doc);

        // ensure category exists
        if (!categories.contains("Course")) {
          categories.add("Course");
        }
      }
    }

    documents.refresh();
  }

}
