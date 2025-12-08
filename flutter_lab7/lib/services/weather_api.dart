import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApi {
  // Visual Crossing Weather API
  static const String _baseUrl = 'https://weather.visualcrossing.com';
  static const String _apiKey = 'WCTBRC45LWLJNXU6UJK7LUXSZ'; // Ваш ключ

  Future<Weather> getWeather(String city) async {
    try {
      print('Visual Crossing: запрос погоды для города: $city');
      
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/VisualCrossingWebServices/rest/services/timeline/'
          '$city'
          '?unitGroup=metric'          // метрическая система
          '&key=$_apiKey'
          '&contentType=json'
          '&lang=ru'                  // русский язык
          '&include=current'          // текущая погода
        ),
      );

      print('Visual Crossing Response status: ${response.statusCode}');
      print('Visual Crossing Response body: ${response.body.substring(0, 200)}...');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return _parseVisualCrossingData(jsonData);
      } else if (response.statusCode == 400) {
        throw Exception('Город "$city" не найден или неверный запрос');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Неверный API ключ. Проверьте ключ.');
      } else if (response.statusCode == 429) {
        throw Exception('Превышен лимит запросов. Попробуйте позже.');
      } else {
        throw Exception('Ошибка API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Ошибка получения погоды: $e');
      throw Exception('Ошибка соединения: ${e.toString()}');
    }
  }

  Future<Weather> getWeatherByLocation(double lat, double lon) async {
    try {
      print('Visual Crossing: запрос по координатам: $lat, $lon');
      
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/VisualCrossingWebServices/rest/services/timeline/'
          '$lat,$lon'
          '?unitGroup=metric'
          '&key=$_apiKey'
          '&contentType=json'
          '&lang=ru'
          '&include=current'
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return _parseVisualCrossingData(jsonData);
      } else {
        throw Exception('Ошибка получения погоды по местоположению');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  Weather _parseVisualCrossingData(Map<String, dynamic> json) {
    // Текущая погода
    final currentConditions = json['currentConditions'];
    final address = json['resolvedAddress'] ?? json['address'] ?? 'Неизвестно';
    
    final temp = currentConditions['temp'].toDouble();
    final feelsLike = currentConditions['feelslike'].toDouble();
    final humidity = (currentConditions['humidity'] * 100).toInt();
    final pressure = currentConditions['pressure'].toDouble();
    final windSpeed = currentConditions['windspeed'].toDouble();
    
    // Описание погоды
    final conditions = currentConditions['conditions'] ?? '';
    final icon = currentConditions['icon'] ?? 'clear-day';
    
    // Влажность для расчета точки росы
    final dewPoint = _calculateDewPoint(temp, humidity);
    
    // Направление ветра
    final windDir = currentConditions['winddir']?.toDouble() ?? 0;
    final windDirection = _getWindDirection(windDir);
    
    // Форматируем название города (берем первую часть адреса)
    final cityParts = address.split(',');
    final cityName = cityParts.isNotEmpty ? cityParts[0].trim() : 'Неизвестно';

    return Weather(
      city: cityName,
      temperature: temp,
      feelsLike: feelsLike,
      humidity: humidity,
      pressure: pressure,
      windSpeed: windSpeed,
      description: _formatDescription(conditions, windDirection, windSpeed),
      iconCode: icon,
      timestamp: DateTime.now(),
      dewPoint: dewPoint,
    );
  }

  // Форматирование описания погоды
  String _formatDescription(String conditions, String windDirection, double windSpeed) {
    String description = '';
    
    // Преобразуем условия
    if (conditions.isNotEmpty) {
      description = _translateConditions(conditions);
    }
    
    // Добавляем информацию о ветре
    if (windDirection.isNotEmpty && windSpeed > 0) {
      if (description.isNotEmpty) {
        description += ', ';
      }
      description += 'ветер $windDirection ${windSpeed.toStringAsFixed(1)} м/с';
    }
    
    return description.isNotEmpty ? description : 'Погодные данные';
  }

  // Перевод условий погоды
  String _translateConditions(String conditions) {
    const translations = {
      'Clear': 'Ясно',
      'Partially cloudy': 'Переменная облачность',
      'Overcast': 'Пасмурно',
      'Rain': 'Дождь',
      'Snow': 'Снег',
      'Rain, Partially cloudy': 'Дождь, переменная облачность',
      'Rain, Overcast': 'Дождь, пасмурно',
      'Snow, Partially cloudy': 'Снег, переменная облачность',
      'Snow, Overcast': 'Снег, пасмурно',
      'Thunderstorm': 'Гроза',
      'Fog': 'Туман',
      'Windy': 'Ветрено',
    };
    
    return translations[conditions] ?? conditions;
  }

  // Направление ветра
  String _getWindDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'северный';
    if (degrees >= 22.5 && degrees < 67.5) return 'северо-восточный';
    if (degrees >= 67.5 && degrees < 112.5) return 'восточный';
    if (degrees >= 112.5 && degrees < 157.5) return 'юго-восточный';
    if (degrees >= 157.5 && degrees < 202.5) return 'южный';
    if (degrees >= 202.5 && degrees < 247.5) return 'юго-западный';
    if (degrees >= 247.5 && degrees < 292.5) return 'западный';
    return 'северо-западный';
  }

  // Расчет точки росы
  static double _calculateDewPoint(double tempC, int humidity) {
    if (humidity <= 0 || humidity > 100) return tempC;
    
    final a = 17.27;
    final b = 237.7;
    final alpha = ((a * tempC) / (b + tempC)) + log(humidity / 100.0);
    return (b * alpha) / (a - alpha);
  }

  
  }
