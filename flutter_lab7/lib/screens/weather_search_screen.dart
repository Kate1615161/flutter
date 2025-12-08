import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lab7/cubit/weather_cubit.dart';
import 'package:lab7/cubit/weather_state.dart';
import 'package:lab7/models/weather_model.dart';

class WeatherSearchScreen extends StatefulWidget {
  const WeatherSearchScreen({Key? key}) : super(key: key);

  @override
  _WeatherSearchScreenState createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  final TextEditingController _cityController = TextEditingController();
  final List<String> _popularCities = ['Москва', 'Лондон', 'Нью-Йорк', 'Токио', 'Париж'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavoriteCities();
    });
  }

  void _loadFavoriteCities() {
    BlocProvider.of<WeatherCubit>(context).loadFavoriteCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          // Обработка состояния FavoriteCitiesLoaded
          if (state is FavoriteCitiesLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _popularCities.addAll(
                  state.cities.where((city) => !_popularCities.contains(city)),
                );
              });
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Поиск
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'Город',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_cityController.text.isNotEmpty) {
                          BlocProvider.of<WeatherCubit>(context)
                              .fetchWeather(_cityController.text);
                        }
                      },
                      child: const Text('Найти'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Популярные города
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _popularCities.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(_popularCities[index]),
                          selected: false,
                          onSelected: (selected) {
                            BlocProvider.of<WeatherCubit>(context)
                                .fetchWeather(_popularCities[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                
                // Состояние
                if (state is WeatherLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is WeatherError)
                  Expanded(
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (state is WeatherLoaded)
                  _buildWeatherInfo(state.weather)
                else
                  const Expanded(
                    child: Center(
                      child: Text('Введите город для поиска'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherInfo(Weather weather) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      weather.city,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      weather.description,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildWeatherDetail('Ощущается как', '${weather.feelsLike.toStringAsFixed(1)}°C'),
                    _buildWeatherDetail('Влажность', '${weather.humidity}%'),
                    _buildWeatherDetail('Давление', '${weather.pressure.toStringAsFixed(0)} hPa'),
                    _buildWeatherDetail('Скорость ветра', '${weather.windSpeed.toStringAsFixed(1)} м/с'),
                    _buildWeatherDetail('Точка росы', '${weather.dewPoint.toStringAsFixed(1)}°C'),
                    const SizedBox(height: 20),
                    Text(
                      'Обновлено: ${_formatTime(weather.timestamp)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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

  Widget _buildWeatherDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}