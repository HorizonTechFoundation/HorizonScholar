import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/cgpa_calc_controller.dart';
import '../controllers/cgpa_controller.dart';
import '../controllers/course_controller.dart';
import '../controllers/document_controller.dart';
import '../controllers/theme_controller.dart'; // AppTheme + ThemeController + AppPalette

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  final CgpaCalcController cgpaCalcController =
      Get.isRegistered<CgpaCalcController>()
          ? Get.find<CgpaCalcController>()
          : Get.put(CgpaCalcController());

  final CgpaController cgpaController =
      Get.isRegistered<CgpaController>()
          ? Get.find<CgpaController>()
          : Get.put(CgpaController());

  final CourseController courseController =
      Get.isRegistered<CourseController>()
          ? Get.find<CourseController>()
          : Get.put(CourseController());

  final DocumentController documentController =
      Get.isRegistered<DocumentController>()
          ? Get.find<DocumentController>()
          : Get.put(DocumentController());

  @override
  Widget build(BuildContext context) {
    // Entire screen listens to theme changes
    return Obx(() {
      final palette = themeController.palette;

      return Scaffold(
        backgroundColor: palette.bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(palette),
                const SizedBox(height: 18),
                _buildThemeSection(palette),
                const SizedBox(height: 22),
                _buildDataSection(context, palette),
                const SizedBox(height: 22),
                _buildPreferencesSection(palette),
                const SizedBox(height: 22),
                _buildAboutSection(context, palette),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader(AppPalette palette) {
    return Text(
      "Settings",
      style: GoogleFonts.righteous(
        fontSize: 24,
        color: palette.blackMain,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // THEME SECTION
  // ---------------------------------------------------------------------------

  Widget _buildThemeSection(AppPalette palette) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(palette),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Theme",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: palette.blackMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Pick a mood for Horizon Scholar.",
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ThemeChip(
                  label: "Horizon Blue",
                  theme: AppTheme.horizonblue,
                  isSelected:
                      themeController.selectedTheme.value == AppTheme.horizonblue,
                  color: const Color(0xFF146C94),
                  onTap: () => themeController.changeTheme(AppTheme.horizonblue),
                ),
                _ThemeChip(
                  label: "Rosé Glow",
                  theme: AppTheme.roseglow,
                  isSelected: themeController.selectedTheme.value ==
                      AppTheme.roseglow,
                  color: const Color(0xFFDD88CF),
                  onTap: () => themeController.changeTheme(AppTheme.roseglow),
                ),
                _ThemeChip(
                  label: "Evergreen",
                  theme: AppTheme.evergreen,
                  isSelected: themeController.selectedTheme.value ==
                      AppTheme.evergreen,
                  color: const Color(0xFF2E7D32),
                  onTap: () => themeController.changeTheme(AppTheme.evergreen),
                ),
                _ThemeChip(
                  label: "Midnight Gold",
                  theme: AppTheme.midnightgold,
                  isSelected:
                      themeController.selectedTheme.value == AppTheme.midnightgold,
                  color: const Color(0xFFFFC052),
                  onTap: () => themeController.changeTheme(AppTheme.midnightgold),
                ),
                _ThemeChip(
                  label: "Coffee",
                  theme: AppTheme.coffee,
                  isSelected:
                      themeController.selectedTheme.value == AppTheme.coffee,
                  color: const Color(0xFF74512D),
                  onTap: () => themeController.changeTheme(AppTheme.coffee),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATA & STORAGE SECTION
  // ---------------------------------------------------------------------------

  Widget _buildDataSection(BuildContext context, AppPalette palette) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(palette),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Data & Storage",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: palette.blackMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Manage the data stored on this device.",
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),

          // Clear all data
          _SettingsTile(
            icon: Icons.delete_forever_rounded,
            iconColor: Colors.redAccent,
            title: "Clear ALL data",
            subtitle: "Remove CGPA, subjects, courses and documents.",
            onTap: () {
              _confirmActionWithDelete(
                context,
                title: "Clear all data?",
                message:
                    "This will delete CGPA records, subjects, courses and documents.\n\nType \"delete\" to confirm.",
                onConfirm: () async {
                  await cgpaCalcController.clearAllCgpaData();
                  await courseController.clearAllCourses();
                  await documentController.clearAllDocuments();
                  Get.back();
                  _showSnack("All data cleared");
                },
              );
            },
          ),

          const Divider(height: 18),

          // Clear CGPA data
          _SettingsTile(
            icon: Icons.calculate_rounded,
            iconColor: palette.primary,
            title: "Clear CGPA data",
            subtitle: "Reset all CGPA entries, GPAs and subject grades.",
            onTap: () {
              _confirmActionWithDelete(
                context,
                title: "Clear CGPA data?",
                message:
                    "All CGPA records, GPA per semester and subject grades will be removed.\n\nType \"delete\" to confirm.",
                onConfirm: () async {
                  await cgpaCalcController.clearAllCgpaData();
                  Get.back();
                  _showSnack("CGPA data cleared");
                },
              );
            },
          ),

          // Clear course data
          _SettingsTile(
            icon: Icons.menu_book_rounded,
            iconColor: Colors.deepPurple,
            title: "Clear course data",
            subtitle: "Remove saved courses and linked certificates.",
            onTap: () {
              _confirmActionWithDelete(
                context,
                title: "Clear course data?",
                message:
                    "All saved courses and linked course documents will be removed.\n\nType \"delete\" to confirm.",
                onConfirm: () async {
                  await courseController.clearAllCourses();
                  Get.back();
                  _showSnack("Course data cleared");
                },
              );
            },
          ),

          // Clear document vault
          _SettingsTile(
            icon: Icons.folder_off_rounded,
            iconColor: Colors.orange,
            title: "Clear document vault",
            subtitle: "Delete all saved documents from the Vault.",
            onTap: () {
              _confirmActionWithDelete(
                context,
                title: "Clear documents?",
                message:
                    "All documents in the Vault will be deleted from this device.\n\nType \"delete\" to confirm.",
                onConfirm: () async {
                  await documentController.clearAllDocuments();
                  Get.back();
                  _showSnack("Documents cleared");
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EXPERIENCE / EXTRA PREFERENCES
  // ---------------------------------------------------------------------------

  Widget _buildPreferencesSection(AppPalette palette) {
    final RxBool haptics = true.obs;
    final RxBool smartTips = true.obs;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(palette),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Experience",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: palette.blackMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Fine-tune how the app behaves.",
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),

          Obx(
            () => _SettingsSwitchTile(
              icon: Icons.vibration_rounded,
              iconColor: palette.primary,
              title: "Haptic feedback",
              subtitle: "Small vibrations when you tap important buttons.",
              value: haptics.value,
              onChanged: (v) => haptics.value = v,
            ),
          ),

          const SizedBox(height: 6),

          Obx(
            () => _SettingsSwitchTile(
              icon: Icons.tips_and_updates_rounded,
              iconColor: Colors.amber[800]!,
              title: "Smart tips",
              subtitle: "Show study tips and shortcuts on the home screen.",
              value: smartTips.value,
              onChanged: (v) => smartTips.value = v,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ABOUT SECTION
  // ---------------------------------------------------------------------------

  Widget _buildAboutSection(BuildContext context, AppPalette palette) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(palette),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: palette.blackMain,
            ),
          ),
          const SizedBox(height: 10),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: palette.primary,
            title: "About Horizon Scholar",
            subtitle: "Version 1.0.0 • Made for students",
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: palette.whiteMain,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 42,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: palette.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.school_rounded,
                                color: palette.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Horizon Scholar",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Your academic companion for CGPA, courses and documents.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Built by Horizon",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: palette.blackMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "This app helps you track semesters, organize course info and keep important documents safe in one place.",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.mail_outline_rounded, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "support@horizon.app",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.public_rounded, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "horizon-scholar.app",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  BoxDecoration _cardDecoration(AppPalette palette) {
    return BoxDecoration(
      color: palette.whiteMain,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  void _confirmActionWithDelete(
    BuildContext context, {
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) {
    final TextEditingController controller = TextEditingController();
    String currentText = '';

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          final bool isValid = currentText.trim().toLowerCase() == 'delete';

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  onChanged: (val) {
                    setState(() {
                      currentText = val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Type "delete" to confirm',
                    labelStyle: GoogleFonts.poppins(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isValid
                    ? () async {
                        await onConfirm();
                      }
                    : null,
                child: Text(
                  "Delete",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnack(String message) {
    Get.snackbar(
      "Settings",
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: Colors.white,
      borderRadius: 12,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// THEME CHIP
// ---------------------------------------------------------------------------

class _ThemeChip extends StatelessWidget {
  final String label;
  final AppTheme theme;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _ThemeChip({
    required this.label,
    required this.theme,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.09) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BASIC SETTINGS TILE
// ---------------------------------------------------------------------------

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.09),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SWITCH TILE
// ---------------------------------------------------------------------------

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.09),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
