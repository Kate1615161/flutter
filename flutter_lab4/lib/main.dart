import 'package:flutter/material.dart';
import 'screens/main_screen_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор космической скорости',
      debugShowCheckedModeBanner: false,
      home: const MainScreensProvider(),
    );
  }
}