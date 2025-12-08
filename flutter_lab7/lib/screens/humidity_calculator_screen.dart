import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab7/cubit/weather_cubit.dart';
import 'package:lab7/cubit/weather_state.dart';
import 'package:lab7/models/weather_model.dart'; // Добавляем этот импорт

class HumidityCalculatorScreen extends StatefulWidget {
  const HumidityCalculatorScreen({Key? key}) : super(key: key);

  @override
  _HumidityCalculatorScreenState createState() => _HumidityCalculatorScreenState();
}

class _HumidityCalculatorScreenState extends State<HumidityCalculatorScreen> {
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор точки росы'),
        backgroundColor: Colors.orange,
      ),
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {
          if (state is CalculationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Введите параметры для расчета точки росы:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                
                // Температура
                TextField(
                  controller: _tempController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Температура (°C)',
                    prefixIcon: Icon(Icons.thermostat),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Влажность
                TextField(
                  controller: _humidityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Влажность (%)',
                    prefixIcon: Icon(Icons.water_drop),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Кнопки
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final temp = double.tryParse(_tempController.text);
                          final humidity = int.tryParse(_humidityController.text);
                          
                          if (temp != null && humidity != null) {
                            BlocProvider.of<WeatherCubit>(context)
                                .calculateDewPoint(temp, humidity);
                          }
                        },
                        icon: const Icon(Icons.calculate),
                        label: const Text('Рассчитать'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _tempController.clear();
                          _humidityController.clear();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Очистить'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Результат
                if (state is CalculationLoaded)
                  _buildResultCard(state.calculation),
                
                // Объяснение
                const SizedBox(height: 30),
                const Text(
                  'Что означает точка росы:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• <10°C - Сухой воздух'),
                        Text('• 10-16°C - Комфортная влажность'),
                        Text('• 16-18°C - Влажно'),
                        Text('• 18-21°C - Очень влажно'),
                        Text('• >21°C - Невыносимо влажно'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(Calculation calculation) {
    return Card(
      margin: const EdgeInsets.only(top: 30),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Результат расчета:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Температура: ${calculation.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Влажность: ${calculation.humidity}%',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Точка росы:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${calculation.dewPoint.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            _buildInterpretation(calculation.dewPoint),
          ],
        ),
      ),
    );
  }

  Widget _buildInterpretation(double dewPoint) {
    String interpretation;
    Color color;
    
    if (dewPoint < 10) {
      interpretation = 'Сухой воздух';
      color = Colors.blue;
    } else if (dewPoint < 16) {
      interpretation = 'Комфортная влажность';
      color = Colors.green;
    } else if (dewPoint < 18) {
      interpretation = 'Влажно';
      color = Colors.orange;
    } else if (dewPoint < 21) {
      interpretation = 'Очень влажно';
      color = Colors.deepOrange;
    } else {
      interpretation = 'Невыносимо влажно';
      color = Colors.red;
    }
    
    return Column(
      children: [
        Text(
          interpretation,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: dewPoint / 30,
          backgroundColor: Colors.grey[200],
          color: color,
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}