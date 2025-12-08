import 'package:flutter/material.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Разработчик'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Аватар
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Лопаткина Екатерина',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Студент 4 курса',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Контактная информация
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.school, color: Colors.red),
                  title: Text('Группа'),
                  subtitle: Text('ИСТУ-22-2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 0),
                const ListTile(
                  leading: Icon(Icons.email, color: Colors.red),
                  title: Text('Почта'),
                  subtitle: Text('lopatkina.e04@list.ru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 0),
                const ListTile(
                  leading: Icon(Icons.phone, color: Colors.red),
                  title: Text('Телефон'),
                  subtitle: Text('+7 (999) 777-66-55', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // О проекте
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'О проекте',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Лабораторная работа №7',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Тема: "Разработка мобильного приложения погоды"',
                    style: TextStyle(fontSize: 14),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Технологии
                  const Text(
                    'Используемые технологии:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTechChip('Flutter'),
                      _buildTechChip('Cubit/Bloc'),
                      _buildTechChip('Visual Crossing API'),
                      _buildTechChip('Shared Preferences'),
                      _buildTechChip('Image Picker'),
                      _buildTechChip('HTTP'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Функции приложения
                  const Text(
                    'Функции приложения:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFunctionItem('Погода по городам'),
                      _buildFunctionItem('Калькулятор точки росы'),
                      _buildFunctionItem('История запросов'),
                      _buildFunctionItem('Фото термометра'),
                      _buildFunctionItem('Избранные города'),
                      _buildFunctionItem('Локализация (русский)'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Версия
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Версия приложения:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '1.0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String tech) {
    return Chip(
      label: Text(tech),
      backgroundColor: Colors.red[50],
      labelStyle: const TextStyle(color: Colors.red),
    );
  }

  Widget _buildFunctionItem(String function) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text(function),
        ],
      ),
    );
  }
}