import 'package:flutter/material.dart';
//import 'package:get/get.dart';

// Define your pages somewhere
import 'home_screen.dart';
import 'cgpa_screen.dart';
import 'course_screen.dart';
import 'vault_screen.dart';
// import 'settings_screen.dart';

import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  

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
      // SettingsScreen(),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF6F1F1),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 114, 188, 209),
        unselectedItemColor: const Color( 0xFF146C94),
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "CGPA",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: "Courses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: "Vault",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

