import 'package:flutter/material.dart';
import '../../data/models/calculation_model.dart';

@immutable
sealed class HistoryState {
  final List<CalculationModel> calculations;

  const HistoryState({required this.calculations});
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial() : super(calculations: const []);
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading({required super.calculations});
}

final class HistoryLoaded extends HistoryState {
  const HistoryLoaded({required super.calculations});
}

final class HistoryError extends HistoryState {
  final String errorMessage;

  const HistoryError({
    required this.errorMessage,
    required super.calculations,
  });
}