import 'package:flutter/material.dart';
import 'screens/student_screen.dart';

class StudentWebApp extends StatelessWidget {
  const StudentWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentScreen(),
    );
  }
}