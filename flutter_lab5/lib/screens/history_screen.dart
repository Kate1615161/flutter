import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';
import '../data/models/calculation_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit()..loadCalculations(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('История'),
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryInitial || state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoryError) {
              return Center(child: Text(state.errorMessage));
            }

            final calculations = state.calculations;

            if (calculations.isEmpty) {
              return const Center(child: Text('Нет расчетов'));
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Всего расчетов: ${calculations.length}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: calculations.length,
                    itemBuilder: (context, index) {
                      return _buildCalculationItem(calculations[index]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCalculationItem(CalculationModel calculation) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Скорость: ${calculation.velocityMs.toStringAsFixed(2)} м/с',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Масса: ${calculation.mass} кг'),
            Text('Радиус: ${calculation.radius} м'),
            Text('Дата: ${_formatDateTime(calculation.createdAt)}'),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}