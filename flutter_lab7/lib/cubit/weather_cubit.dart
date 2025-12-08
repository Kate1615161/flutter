
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab7/cubit/weather_state.dart';
import '../models/weather_model.dart';
import '../services/weather_api.dart';
import '../services/storage_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherApi _weatherApi;
  final StorageService _storageService;

  WeatherCubit({
    required WeatherApi weatherApi,
    required StorageService storageService,
  })  : _weatherApi = weatherApi,
        _storageService = storageService,
        super(WeatherInitial());

  Future<void> fetchWeather(String city) async {
    emit(WeatherLoading());
    
    try {
      final weather = await _weatherApi.getWeather(city);
      await _storageService.saveWeather(weather);
      await _storageService.addFavoriteCity(city);
      
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError(message: 'Ошибка: $e'));
    }
  }

  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    emit(WeatherLoading());
    
    try {
      final weather = await _weatherApi.getWeatherByLocation(lat, lon);
      await _storageService.saveWeather(weather);
      
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError(message: 'Ошибка: $e'));
    }
  }

  Future<void> loadWeatherHistory() async {
    final history = await _storageService.getWeatherHistory();
    emit(WeatherHistoryLoaded(history: history));
  }

  Future<void> clearWeatherHistory() async {
    await _storageService.clearWeatherHistory();
    emit(WeatherHistoryCleared());
    await loadWeatherHistory();
  }

  Future<void> calculateDewPoint(double temperature, int humidity) async {
    if (humidity < 0 || humidity > 100) {
      emit(CalculationError(message: 'Влажность должна быть от 0 до 100%'));
      return;
    }

    final calculation = Calculation.fromData(temperature, humidity);
    await _storageService.saveCalculation(calculation);
    
    emit(CalculationLoaded(calculation: calculation));
  }

  Future<void> loadCalculationHistory() async {
    final history = await _storageService.getCalculationHistory();
    emit(CalculationHistoryLoaded(history: history));
  }

  Future<void> clearCalculationHistory() async {
    await _storageService.clearCalculationHistory();
    emit(CalculationHistoryCleared());
    await loadCalculationHistory();
  }

  Future<void> loadFavoriteCities() async {
    final cities = await _storageService.getFavoriteCities();
    emit(FavoriteCitiesLoaded(cities: cities));
  }
}