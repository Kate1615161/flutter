import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String mass;
  final String radius;
  final double velocityMs;
  final VoidCallback onNewCalculation;

  const ResultScreen({
    super.key,
    required this.mass,
    required this.radius,
    required this.velocityMs,
    required this.onNewCalculation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Первая космическая скорость:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '${velocityMs.toStringAsFixed(2)} м/с',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${(velocityMs / 1000).toStringAsFixed(2)} км/с',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Исходные данные:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Масса: $mass кг',
                textAlign: TextAlign.center,
              ),
              Text(
                'Радиус: $radius м',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNewCalculation,
                  child: const Text('Новый расчет'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}