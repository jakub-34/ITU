//author: Tomáš Zgút
import 'package:flutter/material.dart';
import 'views/main_screen.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init(); // Initialize Hive
  runApp(const MyApp());
}

/// Class representing the whole aplication
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}
