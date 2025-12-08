import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ThermometerCameraScreen extends StatefulWidget {
  const ThermometerCameraScreen({Key? key}) : super(key: key);

  @override
  _ThermometerCameraScreenState createState() => _ThermometerCameraScreenState();
}

class _ThermometerCameraScreenState extends State<ThermometerCameraScreen> {
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _temperatureHistory = [];

  @override
  void initState() {
    super.initState();
    _loadTemperatureHistory();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Не удалось сделать фото: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Не удалось выбрать фото: $e');
    }
  }

  Future<void> _analyzeTemperature() async {
    if (_capturedImage == null) {
      _showErrorDialog('Сначала сделайте или выберите фото термометра');
      return;
    }

    // Показываем индикатор загрузки
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Анализируем изображение термометра...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Симуляция анализа изображения (2 секунды)
    await Future.delayed(const Duration(seconds: 2));

    // Закрываем диалог загрузки
    Navigator.pop(context);

    // Генерируем реалистичную температуру
    final random = Random();
    final temperature = 36.0 + random.nextDouble() * 2.0; // От 36.0 до 38.0°C
    
    // Показываем результат
    _showTemperatureResult(temperature);
  }

  void _showTemperatureResult(double temperature) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              const Text(
                'Температура определена',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Кружок с температурой
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: _getTemperatureColor(temperature).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getTemperatureColor(temperature),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _getTemperatureColor(temperature),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Статус
              Text(
                _getTemperatureStatus(temperature),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getTemperatureColor(temperature),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Описание
              Text(
                _getTemperatureDescription(temperature),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Кнопки действий
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text('Закрыть'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveTemperatureToHistory(temperature);
                        Navigator.pop(context);
                        _showSuccessMessage();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: _getTemperatureColor(temperature),
                      ),
                      child: const Text(
                        'Сохранить',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 36.0) return Colors.blue;
    if (temperature <= 37.0) return Colors.green;
    if (temperature <= 38.0) return Colors.orange;
    return Colors.red;
  }

  String _getTemperatureStatus(double temperature) {
    if (temperature < 36.0) return 'Пониженная температура';
    if (temperature <= 37.0) return 'Нормальная температура';
    if (temperature <= 38.0) return 'Повышенная температура';
    return 'Высокая температура';
  }

  String _getTemperatureDescription(double temperature) {
    if (temperature < 36.0) {
      return 'Температура ниже нормы. Рекомендуется тепло одеваться.';
    } else if (temperature <= 37.0) {
      return 'Температура в пределах нормы. Продолжайте наблюдение.';
    } else if (temperature <= 38.0) {
      return 'Субфебрильная температура. Рекомендуется отдых и обильное питье.';
    } else {
      return 'Фебрильная температура. Рекомендуется обратиться к врачу.';
    }
  }

  Future<void> _saveTemperatureToHistory(double temperature) async {
    final prefs = await SharedPreferences.getInstance();
    
    final reading = {
      'temperature': temperature,
      'timestamp': DateTime.now().toIso8601String(),
      'imagePath': _capturedImage?.path,
    };
    
    _temperatureHistory.insert(0, reading);
    
    // Сохраняем в SharedPreferences
    final jsonList = _temperatureHistory.map((r) => r.toString()).toList();
    await prefs.setStringList('temperature_history', jsonList);
    
    // Обновляем UI
    setState(() {});
  }

  Future<void> _loadTemperatureHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('temperature_history');
    
    if (jsonList != null) {
      setState(() {
        // Преобразуем строки обратно в Map
        _temperatureHistory = jsonList.map((str) {
          try {
            // Простое преобразование строки в Map (для демо)
            return {
              'temperature': double.parse(str.split("'temperature': ")[1].split(",")[0]),
              'timestamp': str.split("'timestamp': '")[1].split("'")[0],
              'imagePath': str.contains("'imagePath': '") 
                  ? str.split("'imagePath': '")[1].split("'")[0]
                  : null,
            };
          } catch (e) {
            return {'temperature': 36.6, 'timestamp': DateTime.now().toIso8601String()};
          }
        }).toList();
      });
    }
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('История измерений'),
        content: _temperatureHistory.isEmpty
            ? const Text('Нет сохраненных измерений')
            : SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: _temperatureHistory.length,
                  itemBuilder: (context, index) {
                    final reading = _temperatureHistory[index];
                    final temp = reading['temperature'] as double;
                    final timestamp = DateTime.parse(reading['timestamp']);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getTemperatureColor(temp),
                          child: Text(
                            '${temp.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text('${temp.toStringAsFixed(1)}°C'),
                        subtitle: Text(
                          DateFormat('dd.MM.yyyy HH:mm').format(timestamp),
                        ),
                        trailing: reading['imagePath'] != null
                            ? const Icon(Icons.photo, color: Colors.blue, size: 20)
                            : null,
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          if (_temperatureHistory.isNotEmpty)
            TextButton(
              onPressed: () {
                _clearHistory();
                Navigator.pop(context);
              },
              child: const Text('Очистить', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('temperature_history');
    
    setState(() {
      _temperatureHistory.clear();
    });
    
    _showSuccessMessage('История очищена');
  }

  void _showSuccessMessage([String message = 'Температура сохранена']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фото термометра'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _temperatureHistory.isEmpty ? null : _showHistoryDialog,
            tooltip: 'История измерений',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Сфотографируйте термометр для записи показаний',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Превью изображения
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _capturedImage != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _capturedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Готово к анализу',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thermostat,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Фото не сделано',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Сделайте фото или выберите из галереи',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Кнопка анализа (только если есть фото)
            if (_capturedImage != null)
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _analyzeTemperature,
                    icon: const Icon(Icons.analytics),
                    label: const Text('Проанализировать температуру'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            
            // Кнопки фото/галереи
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Сделать фото'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Из галереи'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
            
            // История (если есть записи)
            if (_temperatureHistory.isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                color: Colors.purple[50],
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.purple),
                  title: Text(
                    'Сохранено измерений: ${_temperatureHistory.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Нажмите для просмотра истории'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showHistoryDialog,
                ),
              ),
            ],
            
            // Инструкция
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Инструкция:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('1. Сделайте четкое фото шкалы термометра'),
                    Text('2. Убедитесь, что показания хорошо видны'),
                    Text('3. Нажмите "Проанализировать температуру"'),
                    Text('4. Сохраните результат в историю'),
                    SizedBox(height: 8),
                    Text(
                      'Примечание: Функция анализа имитирует работу системы компьютерного зрения',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}