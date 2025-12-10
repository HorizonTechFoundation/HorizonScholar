import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

// BG
// Secondary & White
// Primary
// Black / Primary

enum AppTheme {
  horizonblue,
  evergreen,
  roseglow,
  midnightgold,
  coffee
}

class AppPalette {
  final Color primary;
  final Color secondary;
  final Color bg;
  final Color minimal;
  final Color whiteMain;
  final Color blackMain;
  final Color accent;
  final Color theme;

  const AppPalette({
    required this.primary,
    required this.secondary,
    required this.bg,
    required this.minimal,
    required this.whiteMain,
    required this.blackMain,
    required this.accent,
    required this.theme,
  });
}

const Map<AppTheme, AppPalette> _palettes = {
  AppTheme.horizonblue: AppPalette(
    primary: Color(0xFF146C94),
    secondary: Color(0xFFFFFFFF),

    bg: Color(0xFFF6F1F1),
    minimal: Color(0xFFF6F1F1),
    whiteMain: Color(0xFFF6F1F1),

    blackMain: Color(0xFF163172),
    accent: Color(0xFF163172),

    theme : Color(0xFFFFFFFF)

  ),
  AppTheme.evergreen: AppPalette(
    primary: Color(0xFF4C763B),
    secondary: Color(0xFFFDFAF6),

    bg: Color(0xFFFAF6E9),
    minimal: Color(0xFFFAF6E9),
    whiteMain: Color(0xFFFAF6E9),

    blackMain: Color(0xFF043915),
    accent: Color(0xFF043915),

    theme : Color(0xFFFFFFFF)

  ),
  AppTheme.roseglow: AppPalette(
    primary: Color(0xFF4B164C),
    secondary: Color(0xFFF8E7F6),

    bg: Color(0xFFF5F5F5),
    minimal: Color(0xFFF5F5F5),
    whiteMain: Color(0xFFF5F5F5),

    blackMain: Color(0xFF4B164C),
    accent: Color(0xFF4B164C),

    theme : Color(0xFFFFFFFF)

  ),
  AppTheme.midnightgold: AppPalette(
    primary: Color(0xFFFFCB74),
    secondary: Color(0xFF2F2F2F),

    bg: Color(0xFF131313),
    minimal: Color(0xFF2F2F2F),
    whiteMain: Color(0xFF131313),

    blackMain: Color(0xFFF6F6F6),
    accent: Color(0xFFF6F6F6),

    theme : Color(0xFF111111)

  ),

  AppTheme.coffee: AppPalette(
    primary: Color(0xFF74512D),
    secondary: Color(0xFFE7D3C0),

    bg: Color(0xFFFCF7EF),
    minimal: Color(0xFFFCF7EF),
    whiteMain: Color(0xFFFCF7EF),

    blackMain: Color(0xFF543310),
    accent: Color(0xFF543310),

    theme : Color(0xFFFFFFFF)

  ),
};

class ThemeController extends GetxController {
  // ✅ Box is injected from main.dart
  final Box _settingsBox;

  ThemeController(this._settingsBox);

  static const _themeKey = 'selectedTheme';

  final Rx<AppTheme> selectedTheme = AppTheme.horizonblue.obs;

  AppPalette get palette => _palettes[selectedTheme.value]!;

  ThemeData get themeData => _themeFromPalette(palette);

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    final savedIndex =
        _settingsBox.get(_themeKey, defaultValue: AppTheme.horizonblue.index);
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
