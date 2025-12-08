import 'package:equatable/equatable.dart';
import 'dart:math';

class Weather extends Equatable {
  final String city;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double pressure;
  final double windSpeed;
  final String description;
  final String iconCode;
  final DateTime timestamp;
  final double dewPoint;

  const Weather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.timestamp,
    required this.dewPoint,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    final data = json['data'][0];
    final temp = data['temp'];
    final humidity = data['rh'];
    
    // Расчет точки росы
    final dewPoint = _calculateDewPoint(temp.toDouble(), humidity);

    return Weather(
      city: city,
      temperature: temp.toDouble(),
      feelsLike: data['app_temp'].toDouble(),
      humidity: humidity,
      pressure: data['pres'].toDouble(),
      windSpeed: data['wind_spd'].toDouble(),
      description: data['weather']['description'],
      iconCode: data['weather']['icon'],
      timestamp: DateTime.now(),
      dewPoint: dewPoint,
    );
  }

  static double _calculateDewPoint(double tempC, int humidity) {
    final a = 17.27;
    final b = 237.7;
    final alpha = ((a * tempC) / (b + tempC)) + log(humidity / 100.0);
    return (b * alpha) / (a - alpha);
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
      'description': description,
      'iconCode': iconCode,
      'timestamp': timestamp.toIso8601String(),
      'dewPoint': dewPoint,
    };
  }

  factory Weather.fromStorage(Map<String, dynamic> json) {
    return Weather(
      city: json['city'],
      temperature: json['temperature'].toDouble(),
      feelsLike: json['feelsLike'].toDouble(),
      humidity: json['humidity'],
      pressure: json['pressure'].toDouble(),
      windSpeed: json['windSpeed'].toDouble(),
      description: json['description'],
      iconCode: json['iconCode'],
      timestamp: DateTime.parse(json['timestamp']),
      dewPoint: json['dewPoint'].toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        city,
        temperature,
        feelsLike,
        humidity,
        pressure,
        windSpeed,
        description,
        iconCode,
        timestamp,
        dewPoint,
      ];
}

// Добавляем класс Calculation в этот же файл
class Calculation extends Equatable {
  final double temperature;
  final int humidity;
  final double dewPoint;
  final DateTime timestamp;

  const Calculation({
    required this.temperature,
    required this.humidity,
    required this.dewPoint,
    required this.timestamp,
  });

  factory Calculation.fromData(double temp, int humidity) {
    final dewPoint = _calculateDewPoint(temp, humidity);
    return Calculation(
      temperature: temp,
      humidity: humidity,
      dewPoint: dewPoint,
      timestamp: DateTime.now(),
    );
  }

  static double _calculateDewPoint(double tempC, int humidity) {
    final a = 17.27;
    final b = 237.7;
    final alpha = ((a * tempC) / (b + tempC)) + log(humidity / 100.0);
    return (b * alpha) / (a - alpha);
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'dewPoint': dewPoint,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Calculation.fromStorage(Map<String, dynamic> json) {
    return Calculation(
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'],
      dewPoint: json['dewPoint'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  List<Object?> get props => [temperature, humidity, dewPoint, timestamp];
}