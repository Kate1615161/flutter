import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import 'dart:convert';

class StorageService {
  static const String _weatherHistoryKey = 'weather_history';
  static const String _calculationHistoryKey = 'calculation_history';
  static const String _favoriteCitiesKey = 'favorite_cities';

  Future<void> saveWeather(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getWeatherHistory();
    
    // Добавляем новую запись в начало
    history.insert(0, weather);
    
    // Сохраняем только последние 50 записей
    if (history.length > 50) {
      history.removeLast();
    }
    
    final jsonList = history.map((w) => w.toJson()).toList();
    await prefs.setString(_weatherHistoryKey, json.encode(jsonList));
  }

  Future<List<Weather>> getWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_weatherHistoryKey);
    
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Weather.fromStorage(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherHistoryKey);
  }

  Future<void> saveCalculation(Calculation calculation) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getCalculationHistory();
    
    history.insert(0, calculation);
    
    if (history.length > 50) {
      history.removeLast();
    }
    
    final jsonList = history.map((c) => c.toJson()).toList();
    await prefs.setString(_calculationHistoryKey, json.encode(jsonList));
  }

  Future<List<Calculation>> getCalculationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_calculationHistoryKey);
    
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Calculation.fromStorage(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearCalculationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_calculationHistoryKey);
  }

  Future<void> addFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final cities = await getFavoriteCities();
    
    if (!cities.contains(city)) {
      cities.add(city);
      await prefs.setStringList(_favoriteCitiesKey, cities);
    }
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  Future<void> removeFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final cities = await getFavoriteCities();
    cities.remove(city);
    await prefs.setStringList(_favoriteCitiesKey, cities);
  }
}