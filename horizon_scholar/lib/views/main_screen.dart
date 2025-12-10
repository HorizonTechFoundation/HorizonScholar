import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Define your pages somewhere
import 'home_screen.dart';
import 'cgpa_screen.dart';
import 'course_screen.dart';
import 'vault_screen.dart';
import 'settings_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import '../controllers/theme_controller.dart'; 


class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final ThemeController themeController = Get.find<ThemeController>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onNavigate: _changeTab),
      CGPAScreen(),
      CourseScreen(),
      VaultScreen(),
      SettingsScreen(),
    ];
    

    return Obx((){
      final palette = themeController.palette;
      return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: _buildBottomBar(
          primary: palette.primary,
          secondary: palette.secondary,
          theme: palette.theme,
          blackMain: palette.blackMain,
        ),
      );
    });
  }

  Widget _buildBottomBar({
      required Color primary,
      required Color secondary,
      required Color theme,
      required Color blackMain,
    }) {
    
    final icons = [
      Icons.home_rounded,
      Icons.calculate,
      Icons.menu_book,
      Icons.lock,
      Icons.settings,
    ];

    final labels = ["Home", "CGPA", "Courses", "Vault", "Settings"];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: blackMain.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () => _onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 18 : 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? primary : theme,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    icons[index],
                    size: 22,
                    color: isSelected ? theme : Colors.grey[700],
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      labels[index],
                      style: GoogleFonts.poppins(
                        color: theme,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
