import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_state.dart';
import 'dart:math';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(const MainScreenInitial());

  static const double G = 6.67430e-11;

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

  void calculateCosmicVelocity() {
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
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final velocity = calculateVelocity(mass, radius);
        
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
    });
  }

  double calculateVelocity(double mass, double radius) {

    return sqrt(G * mass / radius);
  }

  void reset() {
    emit(const MainScreenInitial());
  }
}