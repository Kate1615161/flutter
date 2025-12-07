import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_state.dart';
import '../../data/models/calculation_model.dart';
import '../../data/database_helper.dart';
import '/data/shared_preferences_helper.dart';
import 'dart:math';

class MainScreenCubit extends Cubit<MainScreenState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final SharedPreferencesHelper _sharedPrefsHelper = SharedPreferencesHelper();
  
  static const double G = 6.67430e-11;

  MainScreenCubit() : super(const MainScreenInitial()) {
    _loadLastInput();
  }

  Future<void> _loadLastInput() async {
    try {
      final lastInput = await _sharedPrefsHelper.getLastInput();
      
      emit(MainScreenDataEntry(
        mass: lastInput['mass'] as String,
        radius: lastInput['radius'] as String,
        isAgreed: lastInput['isAgreed'] as bool,
      ));
    } catch (e) {
      // Игнорируем ошибку при загрузке
    }
  }

  void updateMass(String value) {
    if (value.isEmpty) {
      emit(MainScreenDataEntry(
        mass: null,
        massError: null,
        radiusError: state.radiusError,
        radius: state.radius,
        isAgreed: state.isAgreed,
        cosmicVelocity: null,
      ));
      return;
    }

    final mass = double.tryParse(value);
    if (mass == null || mass <= 0) {
      emit(MainScreenDataEntry(
        mass: value,
        massError: 'Масса должна быть положительным числом',
        radiusError: state.radiusError,
        radius: state.radius,
        isAgreed: state.isAgreed,
        cosmicVelocity: null,
      ));
    } else {
      emit(MainScreenDataEntry(
        mass: value,
        massError: null,
        radiusError: state.radiusError,
        radius: state.radius,
        isAgreed: state.isAgreed,
        cosmicVelocity: null,
      ));
    }
  }

  void updateRadius(String value) {
    if (value.isEmpty) {
      emit(MainScreenDataEntry(
        radius: null,
        radiusError: null,
        massError: state.massError,
        mass: state.mass,
        isAgreed: state.isAgreed,
        cosmicVelocity: null,
      ));
      return;
    }

    final radius = double.tryParse(value);
    if (radius == null || radius <= 0) {
      emit(MainScreenDataEntry(
        radius: value,
        radiusError: 'Радиус должен быть положительным числом',
        massError: state.massError,
        mass: state.mass,
        isAgreed: state.isAgreed,
        cosmicVelocity: null,
      ));
    } else {
      emit(MainScreenDataEntry(
        radius: value,
        radiusError: null,
        massError: state.massError,
        mass: state.mass,
        isAgreed: state.isAgreed,
        cosmicVelocity: null,
      ));
    }
  }

  void updateAgreement(bool value) {
    emit(MainScreenDataEntry(
      mass: state.mass,
      radius: state.radius,
      massError: state.massError,
      radiusError: state.radiusError,
      isAgreed: value,
      cosmicVelocity: null,
    ));
  }

  Future<void> calculateCosmicVelocity() async {
    if (state.mass == null || state.mass!.isEmpty ||
        state.radius == null || state.radius!.isEmpty) {
      emit(MainScreenError(
        errorMessage: 'Заполните все поля',
        mass: state.mass,
        radius: state.radius,
        isAgreed: state.isAgreed,
      ));
      return;
    }

    final mass = double.tryParse(state.mass!);
    final radius = double.tryParse(state.radius!);
    
    if (mass == null || mass <= 0) {
      emit(MainScreenError(
        errorMessage: 'Масса должна быть положительным числом',
        mass: state.mass,
        radius: state.radius,
        isAgreed: state.isAgreed,
      ));
      return;
    }
    
    if (radius == null || radius <= 0) {
      emit(MainScreenError(
        errorMessage: 'Радиус должен быть положительным числом',
        mass: state.mass,
        radius: state.radius,
        isAgreed: state.isAgreed,
      ));
      return;
    }

    if (!state.isAgreed) {
      emit(MainScreenError(
        errorMessage: 'Необходимо согласие на обработку данных',
        mass: state.mass,
        radius: state.radius,
        isAgreed: state.isAgreed,
      ));
      return;
    }

    emit(MainScreenLoading(
      mass: state.mass,
      radius: state.radius,
      isAgreed: state.isAgreed,
    ));

    try {
      final velocity = _calculateVelocity(mass, radius);
      final velocityKmS = velocity / 1000;
      
      await _sharedPrefsHelper.saveLastInput(
        mass: state.mass!,
        radius: state.radius!,
        isAgreed: state.isAgreed,
      );
      
      await _saveCalculationToDatabase(
        mass: state.mass!,
        radius: state.radius!,
        velocityMs: velocity,
        velocityKmS: velocityKmS,
      );
      
      await _sharedPrefsHelper.incrementCalculationCount();
      
      emit(MainScreenCalculation(
        mass: state.mass,
        radius: state.radius,
        cosmicVelocity: velocity,
      ));
    } catch (e) {
      emit(MainScreenError(
        errorMessage: 'Ошибка расчета: $e',
        mass: state.mass,
        radius: state.radius,
        isAgreed: state.isAgreed,
      ));
    }
  }

  Future<void> _saveCalculationToDatabase({
    required String mass,
    required String radius,
    required double velocityMs,
    required double velocityKmS,
  }) async {
    final calculation = CalculationModel(
      mass: mass,
      radius: radius,
      velocityMs: velocityMs,
      velocityKmS: velocityKmS,
      createdAt: DateTime.now(),
    );
    
    await _databaseHelper.insertCalculation(calculation);
  }

  double _calculateVelocity(double mass, double radius) {
    return sqrt(G * mass / radius);
  }

  void reset() {
    emit(const MainScreenInitial());
  }
}