import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lab7/cubit/weather_cubit.dart';
import 'package:lab7/cubit/weather_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Загружаем обе истории при открытии экрана
      BlocProvider.of<WeatherCubit>(context).loadWeatherHistory();
      BlocProvider.of<WeatherCubit>(context).loadCalculationHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.cloud), text: 'Погода'),
            Tab(icon: Icon(Icons.calculate), text: 'Расчеты'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _WeatherHistoryTab(),
          _CalculationHistoryTab(),
        ],
      ),
    );
  }
}

class _WeatherHistoryTab extends StatefulWidget {
  const _WeatherHistoryTab({Key? key}) : super(key: key);

  @override
  __WeatherHistoryTabState createState() => __WeatherHistoryTabState();
}

class __WeatherHistoryTabState extends State<_WeatherHistoryTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<WeatherCubit>(context).loadWeatherHistory();
    });
  }

  Widget _buildEmptyState(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherHistoryLoaded) {
          final history = state.history;
          
          if (history.isEmpty) {
            return _buildEmptyState(Icons.cloud_off, 'Нет истории погоды');
          }
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Всего записей: ${history.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        BlocProvider.of<WeatherCubit>(context)
                            .clearWeatherHistory();
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Очистить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final weather = history[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            '${weather.temperature.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(weather.city),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature.toStringAsFixed(1)}°C, ${weather.description}',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd.MM.yyyy HH:mm').format(weather.timestamp),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Можно добавить просмотр деталей
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is WeatherHistoryCleared) {
          // После очистки перезагружаем историю
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<WeatherCubit>(context).loadWeatherHistory();
          });
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _CalculationHistoryTab extends StatefulWidget {
  const _CalculationHistoryTab({Key? key}) : super(key: key);

  @override
  __CalculationHistoryTabState createState() => __CalculationHistoryTabState();
}

class __CalculationHistoryTabState extends State<_CalculationHistoryTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<WeatherCubit>(context).loadCalculationHistory();
    });
  }

  Widget _buildEmptyState(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is CalculationHistoryLoaded) {
          final history = state.history;
          
          if (history.isEmpty) {
            return _buildEmptyState(Icons.history, 'Нет истории расчетов');
          }
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Всего расчетов: ${history.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        BlocProvider.of<WeatherCubit>(context)
                            .clearCalculationHistory();
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Очистить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final calculation = history[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Text(
                            '${calculation.dewPoint.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          'Точка росы: ${calculation.dewPoint.toStringAsFixed(1)}°C',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Температура: ${calculation.temperature.toStringAsFixed(1)}°C, '
                              'Влажность: ${calculation.humidity}%',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd.MM.yyyy HH:mm').format(calculation.timestamp),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is CalculationHistoryCleared) {
          // После очистки перезагружаем историю
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<WeatherCubit>(context).loadCalculationHistory();
          });
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}