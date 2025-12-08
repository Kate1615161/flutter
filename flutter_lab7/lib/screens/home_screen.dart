import 'package:flutter/material.dart';
import 'package:lab7/screens/developer_screen.dart';
import 'package:lab7/screens/history_screen.dart';
import 'package:lab7/screens/humidity_calculator_screen.dart';
import 'package:lab7/screens/thermometer_camera_screen.dart';
import 'package:lab7/screens/weather_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погодное приложение'),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _buildFeatureCard(
            context,
            Icons.cloud,
            'Погода',
            Colors.blue,
            const WeatherSearchScreen(),
          ),
          _buildFeatureCard(
            context,
            Icons.history,
            'История',
            Colors.green,
            const HistoryScreen(),
          ),
          _buildFeatureCard(
            context,
            Icons.calculate,
            'Калькулятор',
            Colors.orange,
            const HumidityCalculatorScreen(),
          ),
          _buildFeatureCard(
            context,
            Icons.camera_alt,
            'Термометр',
            Colors.purple,
            const ThermometerCameraScreen(),
          ),
          _buildFeatureCard(
            context,
            Icons.person,
            'Разработчик',
            Colors.red,
            const DeveloperScreen(),
          ),
          _buildFeatureCard(
            context,
            Icons.info,
            'О приложении',
            Colors.teal,
            _showAboutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    dynamic destination,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (destination is Widget) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          } else if (destination is Function) {
            destination(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О приложении'),
        content: const Text(
          'Погодное приложение с расчетом точки росы\n\n'
          'Функции:\n'
          '• Погода через Weatherbit API\n'
          '• Расчет точки росы\n'
          '• История запросов\n'
          '• Фотографирование термометра\n'
          '• Сохранение данных\n\n'
          'Архитектура: Cubit/Bloc\n'
          'Версия: 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}