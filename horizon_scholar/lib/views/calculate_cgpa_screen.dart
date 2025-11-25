import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/cgpa_calc_controller.dart';
import '../models/subject_model.dart';

class CalculateCgpaScreen extends StatefulWidget {
  const CalculateCgpaScreen({super.key});

  @override
  State<CalculateCgpaScreen> createState() => _CalculateCgpaScreenState();
}

class _CalculateCgpaScreenState extends State<CalculateCgpaScreen> {
  static const _bgColor = Color(0xFFF6F1F1);
  static const _primary = Color(0xFF146C94);

  final CgpaCalcController calcController = Get.find<CgpaCalcController>();

  int _selectedSemester = 1;

  List<SubjectModel> _subjectsForSem(List<SubjectModel> all, int sem) {
    return all.where((s) => s.semester == sem).toList();
  }

  // ------------------- SUBJECT PICKER (TEMPLATES) -------------------

  void _showSubjectPickerBottomSheet(BuildContext context, int semester) {
    final searchText = ''.obs;

    // Don't capture templates into a local final List.
    // Always read from controller so you see latest data.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF6F1F1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Text(
                        "Choose Subject",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Search box (doesn't actually need Obx)
                  TextField(
                    onChanged: (val) => searchText.value = val,
                    decoration: InputDecoration(
                      hintText: "Search by code or name",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List of subjects
                  Expanded(
                    child: Obx(() {
                      final templates = calcController.templates; // new every time
                      final query = searchText.value.toLowerCase();

                      final filtered = templates.where((s) {
                        final code = (s.code).toLowerCase();
                        final name = s.name.toLowerCase();

                        if (query.isEmpty) return true;

                        return code.contains(query) || name.contains(query);
                      }).toList()
                        ..sort((a, b) {
                          final codeA = a.code;
                          final codeB = b.code;
                          return codeA.compareTo(codeB);
                        });

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text(
                            "No subjects found.\nTap 'Add new subject manually' instead.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: filtered.length,
                        itemBuilder: (_, index) {
                          final subject = filtered[index];

                          final displayCode =
                              (subject.code == "")
                                  ? "No Code"
                                  : subject.code;

                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                "$displayCode - ${subject.name}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "${subject.credits.toStringAsFixed(1)} credits",
                                style: const TextStyle(fontSize: 12),
                              ),
                              onTap: () async {
                                // If template has no code, reject it gracefully
                                if (subject.code == "" ||
                                    subject.code.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "This template has no course code. Please edit/add it manually.",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                await calcController.addSubjectFromTemplate(
                                  subject,
                                  semester,
                                );
                                await calcController.recalculateAll();
                                Navigator.of(ctx).pop();
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 8),

                  // Add new button at bottom
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _showAddSubjectDialog(context, semester);
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Color(0xFF146C94),
                      ),
                      label: const Text(
                        "Can't find your subject? Add manually",
                        style: TextStyle(color: Color(0xFF146C94)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  // ------------------- ADD SUBJECT OPTIONS SHEET -------------------

  void _showAddSubjectOptions(BuildContext context, int semester) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF6F1F1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Add subject to semester",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.list_alt_outlined),
                title: const Text("Choose from subject list"),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showSubjectPickerBottomSheet(context, semester);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Add new subject manually"),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showAddSubjectDialog(context, semester);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------- ADD SUBJECT DIALOG (MANUAL) -------------------

  void _showAddSubjectDialog(BuildContext context, int semester) {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final creditsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFFF6F1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Subject",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Subject code
                  TextField(
                    controller: codeCtrl,
                    decoration: InputDecoration(
                      labelText: "Subject Code",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.qr_code_2),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subject name
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: "Subject Name",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.menu_book_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Credits
                  TextField(
                    controller: creditsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Credits",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.numbers),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Color(0xFF146C94)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF146C94),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final name = nameCtrl.text.trim();
                          final code = codeCtrl.text.trim();
                          final creditsStr = creditsCtrl.text.trim();
                          final grade = "O";

                          if (name.isEmpty ||
                              code.isEmpty ||
                              creditsStr.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Code, name and credits are required",
                                ),
                              ),
                            );
                            return;
                          }

                          final credits = double.tryParse(creditsStr) ?? 0;
                          if (credits <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Credits must be > 0"),
                              ),
                            );
                            return;
                          }

                          await calcController.addSubject(
                            name: name,
                            code: code,
                            credits: credits,
                            semester: semester,
                            grade: grade.isEmpty ? "" : grade,
                          );

                          Navigator.of(ctx).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------- BUILD -------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          "Calculate CGPA",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          final subjects = calcController.subjects;
          final gpaMap = calcController.gpaPerSem;
          final cgpa = calcController.cgpa.value;

          final subjectsForSem = _subjectsForSem(subjects, _selectedSemester);

          return Column(
            children: [
              // TOP SUMMARY CARD
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAFD3E2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // CGPA text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cgpa == 0.0 ? "--" : cgpa.toStringAsFixed(2),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                              color: _primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Current CGPA (calculated)",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      // Sem-wise GPA summary
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "GPA / Sem",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (gpaMap.isEmpty)
                            Text(
                              "No data",
                              style: GoogleFonts.poppins(fontSize: 12),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: gpaMap.entries.map((e) {
                                return Text(
                                  "S${e.key}: ${e.value.toStringAsFixed(2)}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // SEMESTER CHIPS + ADD SUBJECT
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(8, (index) {
                            final sem = index + 1;
                            final isSelected = _selectedSemester == sem;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  "Sem $sem",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                selected: isSelected,
                                showCheckmark: false,
                                selectedColor: _primary,
                                backgroundColor: const Color(0xFFE5E5E5),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                onSelected: (_) {
                                  setState(() {
                                    _selectedSemester = sem;
                                  });
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () => _showAddSubjectOptions(
                        context,
                        _selectedSemester,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E5E5),
                      ),
                      icon: const Icon(Icons.add, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // SUBJECT LIST
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: subjectsForSem.isEmpty
                      ? Center(
                          child: Text(
                            "No subjects for this semester.\nTap + to add.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: subjectsForSem.length,
                          itemBuilder: (context, index) {
                            final subject = subjectsForSem[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // subject name & credits (and code)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                           (subject.code.isNotEmpty)
                                              ? "${subject.code} - ${subject.name}"
                                              : subject.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${subject.credits.toStringAsFixed(1)} credits",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // grade dropdown
                                  SizedBox(
                                    width: 110,
                                    child: DropdownButtonFormField<String>(
                                      value: subject.grade.isEmpty
                                          ? null
                                          : subject.grade,
                                      items: calcController.gradePoints.keys
                                          .map(
                                            (g) => DropdownMenuItem(
                                              value: g,
                                              child: Text(g),
                                            ),
                                          )
                                          .toList(),
                                      hint: const Text("Grade"),
                                      onChanged: (val) {
                                        if (val != null) {
                                          calcController.updateSubjectGrade(
                                            subject,
                                            val,
                                          );
                                        }
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF6F1F1),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 4),

                                  // delete subject
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await calcController
                                          .removeSubject(subject);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),

              // BOTTOM BUTTON
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 5,
                      ),
                    ),
                    onPressed: () async {
                      await calcController.calculateAndSave();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("CGPA & GPA saved to Hive"),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save,
                          color: Color(0xffF6F1F1),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Calculate & Save CGPA",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color(0xffF6F1F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
