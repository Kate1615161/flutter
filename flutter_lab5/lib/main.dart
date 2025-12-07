import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/cubit/main_screen_cubit.dart';
import 'screens/main_screen.dart';

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
      home: BlocProvider(
        create: (context) => MainScreenCubit(),
        child: const MainScreen(),
      ),
    );
  }
}