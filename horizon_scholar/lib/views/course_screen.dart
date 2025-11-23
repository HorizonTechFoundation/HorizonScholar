import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/course_controller.dart';
import '../models/course_model.dart';

class CourseScreen extends StatelessWidget {
  final CourseController courseController = Get.put(CourseController());

  CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),

      // ---------- FAB ADD BUTTON ----------
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCourseDialog(context),
        backgroundColor: Color(0xFFAFD3E2),
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Title + small add icon (top-right) ----
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Course Manager",
                    style: GoogleFonts.righteous(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  
                ],
              ),

              const SizedBox(height: 24),

              // ---- Stats card (Completed / Pending) ----
              Obx(() {
                final completed = courseController.completedCount;
                final pending = courseController.pendingCount;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAFD3E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$completed",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Completed",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 50,
                        color: const Color(0xFF146C94),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$pending",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Pending",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // ---- Filter row: status + categories + +Category ----
              Obx(() {
                final current = courseController.selectedFilter.value;
                final categories = courseController.categoryList;

                Widget buildFilterChip(String label) {
                  final isSelected = current == label;
                  return GestureDetector(
                    onTap: () => courseController.selectedFilter.value = label,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF146C94)
                            : const Color(0xFFE6E6E6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildFilterChip('All'),
                      buildFilterChip('Completed'),
                      buildFilterChip('Pending'),
                      
                      ...categories.map((cat) => buildFilterChip(cat)).toList(),
                      GestureDetector(
                        onTap: () => _showAddCategoryDialog(context),
                        child: Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFAFD3E2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
                              SizedBox(width: 4),
                              Text(
                                "Category",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // ---- Course list ----
              Expanded(
                child: Obx(() {
                  final courses = courseController.filteredCourses;

                  if (courses.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Course data found",
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      // original index in main list (filtered list is subset)
                      final originalIndex =
                          courseController.courseList.indexOf(course);

                      return GestureDetector(
                        onTap: () =>
                            _showEditCourseDialog(context, course, originalIndex),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Thumbnail (certificate preview)
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD8D8D8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _buildCertificatePreview(
                                  course.certificationPath,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.courseName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      course.courseDescription,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    
                                    // CATEGORY if Any
                                    // if (course.categories.isNotEmpty)
                                    // Builder(
                                    //   builder: (context) {
                                    //     final cats = course.categories;

                                    //     const maxCharLength = 18; // limit by characters
                                    //     int currentLength = 0;

                                    //     List<String> visibleCats = [];
                                    //     List<String> hiddenCats = [];

                                    //     for (var cat in cats) {
                                    //       if (currentLength + cat.length <= maxCharLength) {
                                    //         visibleCats.add(cat);
                                    //         currentLength += cat.length;
                                    //       } else {
                                    //         hiddenCats.add(cat);
                                    //       }
                                    //     }

                                    //     final remainingCount = hiddenCats.length;

                                    //     return Row(
                                    //       children: [
                                    //         // visible chips WITH SPACING
                                    //         ...visibleCats.map((cat) {
                                    //           return Padding(
                                    //             padding: const EdgeInsets.only(right: 6), // <-- SPACE HERE
                                    //             child: Chip(
                                    //               backgroundColor: const Color(0xFFD6E6F2),
                                    //               label: Text(
                                    //                 cat,
                                    //                 style: const TextStyle(
                                    //                   fontSize: 10,
                                    //                   color: Color(0xFF0A4D68),
                                    //                   fontWeight: FontWeight.w400,
                                    //                 ),
                                    //               ),
                                    //               labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                                    //               visualDensity: const VisualDensity(
                                    //                 horizontal: -4,
                                    //                 vertical: -4,
                                    //               ),
                                    //               shape: RoundedRectangleBorder(
                                    //                 borderRadius: BorderRadius.circular(8),
                                    //               ),
                                    //             ),
                                    //           );
                                    //         }).toList(),

                                    //         // "+N more" chip WITH spacing
                                    //         if (remainingCount > 0)
                                    //           Padding(
                                    //             padding: const EdgeInsets.only(left: 6),
                                    //             child: Chip(
                                    //               backgroundColor: const Color(0xFFEAF0F6),
                                    //               label: Text(
                                    //                 '+$remainingCount more',
                                    //                 style: const TextStyle(
                                    //                   fontSize: 10,
                                    //                   color: Color(0xFF555555),
                                    //                   fontWeight: FontWeight.w500,
                                    //                 ),
                                    //               ),
                                    //               labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                                    //               visualDensity: const VisualDensity(
                                    //                 horizontal: -4,
                                    //                 vertical: -4,
                                    //               ),
                                    //               shape: RoundedRectangleBorder(
                                    //                 borderRadius: BorderRadius.circular(8),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //       ],
                                    //     );
                                    //   },
                                    // ),

                                    const SizedBox(height: 4),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: course.isCompleted
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            course.isCompleted ? "Completed" : "Pending",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: course.isCompleted
                                                  ? Colors.green[700]
                                                  : Colors.orange[700],
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================== CERTIFICATE PREVIEW ==================
  Widget _buildCertificatePreview(String path) {
    if (path.isEmpty) {
      return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }

    final ext = path.split('.').last.toLowerCase();

    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
      final file = File(path);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    if (ext == 'pdf') {
      return const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 32,
      );
    }

    return const Icon(Icons.insert_drive_file, color: Colors.grey);
  }

  // ================== ADD COURSE DIALOG ==================
  void _showAddCourseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final certPathController = TextEditingController();
    final isCompleted = false.obs;
    final selectedFileName = ''.obs;
    final selectedCategories = <String>[].obs;

    Future<void> _pickCertificate() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        certPathController.text = file.path!;
        selectedFileName.value = file.name;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Color(0xFFF6F1F1),
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
                  // Title row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Course",
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
                  const SizedBox(height: 8),

                  // Course name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Course name",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.menu_book_outlined),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: "Course description",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      
                      prefixIcon: const Icon(Icons.description_outlined),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),

                  // Upload certificate
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Certificate (optional)",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        FilledButton.icon(
                          onPressed: _pickCertificate,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF146C94),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            selectedFileName.isEmpty
                                ? "Upload certificate"
                                : selectedFileName.value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Categories multi-select
                  Obx(() {
                    final categories = courseController.categoryList;

                    if (categories.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _showAddCategoryDialog(context),
                            icon: const Icon(Icons.add, size: 16, color: Color(0xFF146C94)),
                            label: const Text("Add category" ,style: TextStyle(color: Color(0xFF146C94))),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddCategoryDialog(context),
                              icon: const Icon(Icons.add, size: 16, color: Color(0xFF146C94)),
                              label: const Text("New", style: TextStyle(color: Color(0xFF146C94))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: categories.map((cat) {
                            final isSelected =
                                selectedCategories.contains(cat);
                            return ChoiceChip(
                              backgroundColor: Color(0xFFE9E9E9),
                              selectedColor: const Color(0xFFAFD3E2),
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (val) {
                                if (val) {
                                  selectedCategories.add(cat);
                                } else {
                                  selectedCategories.remove(cat);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 6),

                  // Completed switch
                  Obx(
                    () => SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Completed"),
                      value: isCompleted.value,
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF146C94),
                      onChanged: (val) => isCompleted.value = val,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("Cancel", style: TextStyle(color: Color(0xFF146C94))),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF146C94),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Course name cannot be empty"),
                              ),
                            );
                            return;
                          }

                          final course = CourseModel(
                            courseName: nameController.text.trim(),
                            isCompleted: isCompleted.value,
                            certificationPath:
                                certPathController.text.trim(),
                            courseDescription:
                                descController.text.trim(),
                            categories: selectedCategories.toList(),
                          );

                          courseController.addCourse(course);
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

  // ================== EDIT COURSE DIALOG ==================
  void _showEditCourseDialog(
    BuildContext context,
    CourseModel course,
    int index,
  ) {
    final nameController = TextEditingController(text: course.courseName);
    final descController =
        TextEditingController(text: course.courseDescription);
    final certPathController =
        TextEditingController(text: course.certificationPath);
    final isCompleted = course.isCompleted.obs;
    final selectedCategories =
        (course.categories ?? <String>[]).toList().obs;

    final selectedFileName = (course.certificationPath.isNotEmpty
            ? course.certificationPath
                .split(Platform.pathSeparator)
                .last
            : '')
        .obs;

    Future<void> _pickCertificate() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        certPathController.text = file.path!;
        selectedFileName.value = file.name;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Color(0xFFF6F1F1),
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
                  // Title row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Edit Course",
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
                  const SizedBox(height: 8),

                  // Course name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Course name",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.menu_book_outlined),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      labelText: "Course description",
                      //alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.description_outlined),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),

                  // Upload certificate
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Certificate (optional)",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF146C94),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onPressed: _pickCertificate,
                          icon: const Icon(Icons.upload_file),
                          label: Text(
                            selectedFileName.isEmpty
                                ? "Upload / Change certificate"
                                : selectedFileName.value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Categories multi-select
                  Obx(() {
                    final categories = courseController.categoryList;

                    if (categories.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _showAddCategoryDialog(context),
                            icon: const Icon(Icons.add, size: 16, color: Color(0xFF146C94)),
                            label: const Text("Add category", style: TextStyle(color: Color(0xFF146C94))),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddCategoryDialog(context),
                              icon: const Icon(Icons.add, size: 16, color: Color(0xFF146C94)),
                              label: const Text("New", style: TextStyle(color: Color(0xFF146C94))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: categories.map((cat) {
                            final isSelected =
                                selectedCategories.contains(cat);
                            return ChoiceChip(
                              backgroundColor: Color(0xFFE9E9E9),
                              selectedColor: const Color(0xFFAFD3E2),
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (val) {
                                if (val) {
                                  selectedCategories.add(cat);
                                } else {
                                  selectedCategories.remove(cat);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 6),

                  // Completed switch
                  Obx(
                    () => SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Completed"),
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF146C94),
                      value: isCompleted.value,
                      onChanged: (val) => isCompleted.value = val,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Buttons row: Delete + Update
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Delete
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (confirmCtx) => AlertDialog(
                              backgroundColor: Color(0xFFF6F1F1),
                              title: const Text("Delete course"),
                              content: const Text(
                                "Are you sure you want to delete this course?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(confirmCtx).pop(),
                                  child: const Text("Cancel", style: TextStyle(color: Color(0xFF146C94))),
                                ),
                                TextButton(
                                  onPressed: () {
                                    courseController.deleteCourse(index);
                                    Navigator.of(confirmCtx).pop();
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),

                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text("Cancel", style: TextStyle(color: Color(0xFF146C94))),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF146C94),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              if (nameController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Course name cannot be empty",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final updatedCourse = CourseModel(
                                courseName: nameController.text.trim(),
                                isCompleted: isCompleted.value,
                                certificationPath:
                                    certPathController.text.trim(),
                                courseDescription:
                                    descController.text.trim(),
                                categories: selectedCategories.toList(),
                              );

                              courseController.updateCourse(index, updatedCourse);
                              Navigator.of(ctx).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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

  // ================== ADD CATEGORY DIALOG ==================
  void _showAddCategoryDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Color(0xFFF6F1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "New Category",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: "Category name",
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Cancel", style: TextStyle(color: Color(0xFF146C94))),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          courseController.addCategory(name);
                        }
                        Navigator.of(ctx).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF146C94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
