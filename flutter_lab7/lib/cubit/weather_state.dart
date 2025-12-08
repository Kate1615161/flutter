import 'package:equatable/equatable.dart';
import '../models/weather_model.dart';
import 'dart:io';

abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  
  const WeatherLoaded({required this.weather});
  
  @override
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  
  const WeatherError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class WeatherHistoryLoaded extends WeatherState {
  final List<Weather> history;
  
  const WeatherHistoryLoaded({required this.history});
  
  @override
  List<Object?> get props => [history];
}

class WeatherHistoryCleared extends WeatherState {}

class CalculationLoaded extends WeatherState {
  final Calculation calculation;
  
  const CalculationLoaded({required this.calculation});
  
  @override
  List<Object?> get props => [calculation];
}

class CalculationError extends WeatherState {
  final String message;
  
  const CalculationError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class CalculationHistoryLoaded extends WeatherState {
  final List<Calculation> history;
  
  const CalculationHistoryLoaded({required this.history});
  
  @override
  List<Object?> get props => [history];
}

class CalculationHistoryCleared extends WeatherState {}

class FavoriteCitiesLoaded extends WeatherState {
  final List<String> cities;
  
  const FavoriteCitiesLoaded({required this.cities});
  
  @override
  List<Object?> get props => [cities];
}

class ThermometerPhotoCaptured extends WeatherState {
  final File image;
  
  const ThermometerPhotoCaptured({required this.image});
  
  @override
  List<Object?> get props => [image];
}