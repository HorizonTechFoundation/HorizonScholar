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

// =====

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CgpaModelAdapter());
  Hive.registerAdapter(DocumentModelAdapter());
  Hive.registerAdapter(CourseModelAdapter());

  await Hive.openBox<CgpaModel>('cgpaBox');
  await Hive.openBox<DocumentModel>('documentsBoxV2');
  await Hive.openBox<CourseModel>('courseBox');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Horizon Scholar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MainScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/cgpa', page: () => CGPAScreen()),
        GetPage(name: '/vault', page: () => VaultScreen()),
        GetPage(name: '/courses', page: () => CourseScreen()),
      ],
    );
  }
}
