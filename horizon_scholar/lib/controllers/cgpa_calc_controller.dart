import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/subject_model.dart';
import '../models/gpa_model.dart';
import '../models/cgpa_model.dart';
import 'cgpa_controller.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class CgpaCalcController extends GetxController {
  late Box<SubjectModel> subjectBox;
  late Box<GpaModel> gpaBox;

  /// All subjects (templates + those assigned to semesters)
  final subjects = <SubjectModel>[].obs;

  /// All GPA records (one per semester)
  final gpas = <GpaModel>[].obs;

  /// Current CGPA
  final cgpa = 0.0.obs;

  /// Grade → point mapping
  /// Adjust if your university uses a different scale
  final Map<String, double> gradePoints = {
    'O': 10,
    'A+': 9,
    'A': 8,
    'B+': 7,
    'B': 6,
    'C': 5,
    'U': 0,
    'RA': 0,
  };

  @override
  void onInit() {
    super.onInit();
    subjectBox = Hive.box<SubjectModel>('subjectBox');
    gpaBox = Hive.box<GpaModel>('gpaBox');
    _loadData();
    _seedTemplatesFromCsvIfEmpty();
  }

  Future<void> _seedTemplatesFromCsvIfEmpty() async {
    // If there are already templates (semester == 0), do nothing
    final hasTemplates = subjects.any((s) => s.semester == 0);
    if (hasTemplates) return;

    try {
      // 1. Load CSV string from assets
      final csvString = await rootBundle.loadString('assets/subjects.csv');

      // 2. Split into lines
      final lines = const LineSplitter().convert(csvString);

      if (lines.isEmpty) return;

      // 3. Assume first line is header: code,name,credits
      //    Start from index 1
      final List<SubjectModel> templateList = [];

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        // Simple split by comma; if your names contain commas, you might need a proper CSV parser
        final parts = line.split(',');

        if (parts.length < 3) {
          // Not enough columns → skip
          continue;
        }

        final code = parts[0].trim();
        final name = parts[1].trim();
        final creditsStr = parts[2].trim();
        final credits = double.tryParse(creditsStr) ?? 0;

        if (code.isEmpty || name.isEmpty || credits <= 0) {
          // Invalid row → skip
          continue;
        }

        final subject = SubjectModel(
          semester: 0,     // template
          name: name,
          credits: credits,
          grade: '',       // template has no grade
          code: code,
        );

        templateList.add(subject);
      }

      // 4. Save them in Hive and in observable list
      for (final s in templateList) {
        await subjectBox.add(s);
      }

      subjects.addAll(templateList);
    } catch (e) {
      // Optional: log or show debug message
      print('Error seeding templates from CSV: $e');
    }
  }



  void _loadData() {
    subjects.assignAll(subjectBox.values);
    gpas.assignAll(gpaBox.values);
    _recomputeCgpaFromSubjects();
  }

  /// Subjects in DB that are templates (semester == 0)
  List<SubjectModel> get templates =>
      subjects.where((s) => s.semester == 0).toList();

  /// GPA per semester as a map: sem → gpa
  Map<int, double> get gpaPerSem =>
      {for (final g in gpas) g.semester: g.gpa};

  // ---------------------------------------------------------------------------
  // CRUD & operations
  // ---------------------------------------------------------------------------

  /// Add a subject directly to a semester (manual add dialog)
  Future<void> addSubject({
    required String name,
    required String code,
    required double credits,
    required int semester,
    required String grade,
  }) async {
    if (code.trim().isEmpty) {
      throw ArgumentError("Course code is required");
    }

    final subject = SubjectModel(
      semester: semester,
      name: name,
      credits: credits,
      grade: grade,
      code: code.trim(),
    );

    await subjectBox.add(subject);
    subjects.add(subject);
    await recalculateAll();
  }


  /// Add subject for a semester from a template (template has semester = 0)
  Future<void> addSubjectFromTemplate(
    SubjectModel template,
    int semester,
  ) async {
    if (template.code.trim().isEmpty) {
      // Should normally never happen after you clean templates
      throw ArgumentError("Template must have a course code");
    }

    final subject = SubjectModel(
      semester: semester,
      name: template.name,
      credits: template.credits,
      grade: '',
      code: template.code.trim(),
    );

    await subjectBox.add(subject);
    subjects.add(subject);
    await recalculateAll();
  }


  /// Remove a subject from a semester
  Future<void> removeSubject(SubjectModel subject) async {
    await subject.delete();       // remove from Hive
    subjects.remove(subject);    // remove from list
    await recalculateAll();
  }

  /// Update grade of a subject and recalculate GPAs/CGPA
  Future<void> updateSubjectGrade(
    SubjectModel subject,
    String newGrade,
  ) async {
    subject.grade = newGrade;
    await subject.save();
    await recalculateAll();
  }

  // ---------------------------------------------------------------------------
  // GPA & CGPA calculation
  // ---------------------------------------------------------------------------

  Future<void> recalculateAll() async {
    // Group subjects by semester (ignore templates and empty grades)
    final Map<int, List<SubjectModel>> bySem = {};
    for (final s in subjects) {
      if (s.semester <= 0) continue;      // ignore templates
      if (s.grade.isEmpty) continue;      // ignore not graded yet

      bySem.putIfAbsent(s.semester, () => []).add(s);
    }

    // Clear and recompute GPA box
    gpas.clear();
    await gpaBox.clear();

    int maxSem = 0;

    for (final entry in bySem.entries) {
      final sem = entry.key;
      maxSem = sem > maxSem ? sem : maxSem;
      final subs = entry.value;

      double totalCredits = 0;
      double totalPoints = 0;

      for (final s in subs) {
        final gp = gradePoints[s.grade.toUpperCase()] ?? 0;
        totalCredits += s.credits;
        totalPoints += gp * s.credits;
      }

      if (totalCredits == 0) continue;

      final gpa = totalPoints / totalCredits;
      final gpaModel = GpaModel(semester: sem, gpa: gpa);

      await gpaBox.put(sem, gpaModel); // key by semester
      gpas.add(gpaModel);
    }

    _recomputeCgpaFromSubjects(maxSem: maxSem);
  }

  void _recomputeCgpaFromSubjects({int? maxSem}) {
    double totalCredits = 0;
    double totalPoints = 0;

    for (final s in subjects) {
      if (s.semester <= 0) continue;    // ignore templates
      if (s.grade.isEmpty) continue;    // ignore not graded

      final gp = gradePoints[s.grade.toUpperCase()] ?? 0;
      totalCredits += s.credits;
      totalPoints += gp * s.credits;
    }

    if (totalCredits == 0) {
      cgpa.value = 0;
    } else {
      cgpa.value = totalPoints / totalCredits;
    }

    // Sync into CgpaController (for your CGPA main screen)
    if (Get.isRegistered<CgpaController>()) {
      final cgpaCtrl = Get.find<CgpaController>();

      final currentSem = maxSem ??
          (gpas.isEmpty
              ? 0
              : gpas
                  .map((g) => g.semester)
                  .reduce((a, b) => a > b ? a : b));

      if (cgpaCtrl.cgpaList.isEmpty) {
        cgpaCtrl.addCgpa(
          CgpaModel(cgpa: cgpa.value, currentSem: currentSem),
        );
      } else {
        cgpaCtrl.updateCgpa(
          0,
          CgpaModel(cgpa: cgpa.value, currentSem: currentSem),
        );
      }
    }
  }

  /// Used by "Calculate & Save CGPA" button – just recomputes everything
  Future<void> calculateAndSave() async {
    await recalculateAll();
  }
}
