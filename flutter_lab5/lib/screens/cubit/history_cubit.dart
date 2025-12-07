import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_state.dart';
import '../../data/models/calculation_model.dart';
import '../../data/database_helper.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  HistoryCubit() : super(const HistoryInitial());

  Future<void> loadCalculations() async {
    emit(const HistoryLoading(calculations: []));
    
    try {
      final calculations = await _databaseHelper.getAllCalculations();
      emit(HistoryLoaded(calculations: calculations));
    } catch (e) {
      emit(HistoryError(
        errorMessage: 'Ошибка загрузки истории',
        calculations: [],
      ));
    }
  }

}