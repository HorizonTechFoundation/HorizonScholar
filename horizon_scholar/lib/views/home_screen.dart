import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for navigation

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Horizon Scholar!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/cgpa'); // Navigate to CGPA page
              },
              child: Text('Go to CGPA Page'),
            ),
          ],
        ),
      ),
    );
  }
}
