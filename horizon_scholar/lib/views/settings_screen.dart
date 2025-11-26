import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  static const _bgColor = Color(0xFFF6F1F1);
  //static const _primary = Color(0xFF146C94);
  //static const _accent = Color(0xFFAFD3E2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Obx(() {

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Text("Still In Progress...")
          );
        })
      )
    );
  }
}