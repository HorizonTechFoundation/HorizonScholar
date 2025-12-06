import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

// SCREEN

import "views/main_screen.dart";
import "views/home_screen.dart";
import "views/cgpa_screen.dart";
import "views/course_screen.dart";
import "views/vault_screen.dart";

// ======

// MODELS

import 'models/cgpa_model.dart';
import 'models/document_model.dart';
import 'models/course_model.dart';
import 'models/subject_model.dart';
import 'models/gpa_model.dart';

import 'controllers/cgpa_calc_controller.dart';
import 'controllers/theme_controller.dart';

// =====

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CgpaModelAdapter());
  Hive.registerAdapter(DocumentModelAdapter());
  Hive.registerAdapter(CourseModelAdapter());
  Hive.registerAdapter(SubjectModelAdapter());
  Hive.registerAdapter(GpaModelAdapter());


  await Hive.openBox<CgpaModel>('cgpaBox');
  await Hive.openBox<DocumentModel>('documentsBoxV2');
  await Hive.openBox<CourseModel>('courseBox');
  await Hive.openBox<SubjectModel>('subjectBox');
  await Hive.openBox<GpaModel>('gpaBox');

  final settingsBox = await Hive.openBox('settingsBox');

  Get.put(CgpaCalcController(), permanent: true);
  Get.put(ThemeController(settingsBox), permanent: true);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          title: 'Horizon Scholar',
          debugShowCheckedModeBanner: false,
          theme: themeController.themeData,
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => MainScreen()),
            GetPage(name: '/home', page: () => HomeScreen()),
            GetPage(name: '/cgpa', page: () => CGPAScreen()),
            GetPage(name: '/vault', page: () => VaultScreen()),
            GetPage(name: '/courses', page: () => CourseScreen()),
          ],
        );
      },
    );
  }
}
