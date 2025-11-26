import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/cgpa_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/document_controller.dart';
// import '../screens/cgpa_screen.dart';
// import '../screens/course_screen.dart';
// import '../screens/vault_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, this.onNavigate});

  final void Function(int)? onNavigate;

  static const _bgColor = Color(0xFFF6F1F1);
  static const _primary = Color(0xFF146C94);
  static const _accent = Color(0xFFAFD3E2);

  // Safely get controllers (create if not registered)
  final CgpaController cgpaController =
      Get.isRegistered<CgpaController>() ? Get.find<CgpaController>() : Get.put(CgpaController());

  final CourseController courseController =
      Get.isRegistered<CourseController>() ? Get.find<CourseController>() : Get.put(CourseController());

  final DocumentController documentController =
      Get.isRegistered<DocumentController>() ? Get.find<DocumentController>() : Get.put(DocumentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Obx(() {
          // ----- CGPA DATA -----
          final latest = cgpaController.latestCgpa;
          final cgpa = latest?.cgpa ?? 0.0;
          final currentSem = latest?.currentSem ?? 0;

          // ----- COURSE & DOC DATA -----
          final completedCourses = courseController.completedCount;
          final totalDocuments = documentController.documents.length;
          final recentDocs = documentController.documents.reversed.take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Horizon Scholar",
                      style: GoogleFonts.righteous(
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.code, size: 18, color: _primary),
                          const SizedBox(width: 6),
                          Text(
                            "Horizon",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(
                  "Welcome back !",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 20),

                // TOP CGPA CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, bottom: 20,right: 18, left: 30),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left: percentage / cgpa
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cgpa == 0.0 ? "--" : cgpa.toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 46,
                                color: _primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Current CGPA",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Right: sem info + button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.timeline_outlined, size: 16, color: _primary),
                                const SizedBox(width: 6),
                                Text(
                                  currentSem == 0 ? "No semesters added" : "Upto Sem $currentSem",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              onNavigate?.call(1);
                            },
                            icon: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                            label: Text(
                              "Try New AI Features",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // STATS CARDS ROW
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: "Courses completed",
                        value: completedCourses.toString(),
                        icon: Icons.playlist_add_check_rounded,
                        primary: _primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: "Documents saved",
                        value: totalDocuments.toString(),
                        icon: Icons.folder_special_outlined,
                        primary: _primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // QUICK ACTIONS TITLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quick actions",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Tap to open",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // QUICK ACTION GRID
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _QuickActionButton(
                      icon: Icons.calculate_outlined,
                      label: "CGPA\nCalculator",
                      onTap: () {
                        onNavigate?.call(1);
                      },
                    ),
                    _QuickActionButton(
                      icon: Icons.menu_book_outlined,
                      label: "My\nCourses",
                      onTap: () {
                        onNavigate?.call(2);
                      },
                    ),
                    _QuickActionButton(
                      icon: Icons.lock_outline,
                      label: "Document\nVault",
                      onTap: () {
                        onNavigate?.call(3);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // RECENT DOCUMENTS / FILL EMPTY SPACE USEFULLY
                Text(
                  "Recent documents",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                if (recentDocs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.insert_drive_file_outlined,
                            color: _primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "No documents yet.\nSave your certificates, notes and PDFs in the Vault.",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: recentDocs.map((doc) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _iconForType(doc.type),
                                color: _primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doc.categories.join(' • '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (doc.isFav) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.star, size: 18, color: Colors.amber),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  IconData _iconForType(String type) {
    final t = type.toLowerCase();
    if (t.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (t.contains('jpg') || t.contains('jpeg') || t.contains('png')) {
      return Icons.image_outlined;
    }
    if (t.contains('doc')) return Icons.description_outlined;
    return Icons.insert_drive_file_outlined;
  }
}

/// Small stat card used for "Courses completed" and "Documents saved"
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color primary;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable quick action button (CGPA, Courses, Vault)
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF146C94);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
