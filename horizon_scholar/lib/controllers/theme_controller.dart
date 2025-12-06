import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

enum AppTheme {
  seaBlue,
  forestGreen,
  fireRed,
}

class AppPalette {
  final Color primary;
  final Color secondary;
  final Color bg;
  final Color minimal;
  final Color whiteMain;
  final Color blackMain;
  final Color optional;

  const AppPalette({
    required this.primary,
    required this.secondary,
    required this.bg,
    required this.minimal,
    required this.whiteMain,
    required this.blackMain,
    required this.optional,
  });
}

const Map<AppTheme, AppPalette> _palettes = {
  AppTheme.seaBlue: AppPalette(
    primary: Color(0xFF146C94),
    secondary: Color(0xFF19A7CE),
    bg: Color(0xFFF6F1F1),
    minimal: Color(0xFFE3F2FD),
    whiteMain: Colors.white,
    blackMain: Colors.black87,
    optional: Color(0xFFAFD3E2),
  ),
  AppTheme.forestGreen: AppPalette(
    primary: Color(0xFF2E7D32),
    secondary: Color(0xFF66BB6A),
    bg: Color.fromARGB(255, 136, 255, 0),
    minimal: Color(0xFFE8F5E9),
    whiteMain: Colors.white,
    blackMain: Colors.black87,
    optional: Color(0xFFA5D6A7),
  ),
  AppTheme.fireRed: AppPalette(
    primary: Color(0xFFC62828),
    secondary: Color(0xFFEF5350),
    bg: Color.fromARGB(255, 255, 0, 38),
    minimal: Color(0xFFFFCDD2),
    whiteMain: Colors.white,
    blackMain: Colors.black87,
    optional: Color(0xFFE57373),
  ),
};

class ThemeController extends GetxController {
  // ✅ Box is injected from main.dart
  final Box _settingsBox;

  ThemeController(this._settingsBox);

  static const _themeKey = 'selectedTheme';

  final Rx<AppTheme> selectedTheme = AppTheme.seaBlue.obs;

  AppPalette get palette => _palettes[selectedTheme.value]!;

  ThemeData get themeData => _themeFromPalette(palette);

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    final savedIndex =
        _settingsBox.get(_themeKey, defaultValue: AppTheme.seaBlue.index);
    selectedTheme.value = AppTheme.values[savedIndex];
  }

  void changeTheme(AppTheme theme) {
    selectedTheme.value = theme;
    _settingsBox.put(_themeKey, theme.index);
    Get.changeTheme(_themeFromPalette(_palettes[theme]!));
  }

  ThemeData _themeFromPalette(AppPalette palette) {
    final scheme = ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: palette.primary,
        secondary: palette.secondary,
        surface: palette.bg,
        background: palette.bg,
      ),
      scaffoldBackgroundColor: palette.bg,
      primaryColor: palette.primary,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.primary,
        foregroundColor: palette.whiteMain,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: palette.whiteMain,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.whiteMain,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
