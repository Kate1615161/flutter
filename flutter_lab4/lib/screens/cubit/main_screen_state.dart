import 'package:flutter/material.dart';

@immutable
sealed class MainScreenState {
  final String? massError;
  final String? radiusError;
  final bool isAgreed;
  final String? mass;
  final String? radius;
  final double? cosmicVelocity;
  final bool isLoading;

  const MainScreenState({
    this.massError,
    this.radiusError,
    this.isAgreed = false,
    this.mass,
    this.radius,
    this.cosmicVelocity,
    this.isLoading = false,
  });
}

final class MainScreenInitial extends MainScreenState {
  const MainScreenInitial()
      : super(
          massError: null,
          radiusError: null,
          isAgreed: false,
          mass: null,
          radius: null,
          cosmicVelocity: null,
        );
}

final class MainScreenDataEntry extends MainScreenState {
  const MainScreenDataEntry({
    String? massError,
    String? radiusError,
    bool? isAgreed,
    String? mass,
    String? radius,
    double? cosmicVelocity,
  }) : super(
          massError: massError,
          radiusError: radiusError,
          isAgreed: isAgreed ?? false,
          mass: mass,
          radius: radius,
          cosmicVelocity: cosmicVelocity,
        );
}

final class MainScreenCalculation extends MainScreenState {
  const MainScreenCalculation({
    required String? mass,
    required String? radius,
    required double cosmicVelocity,
    bool isAgreed = true,
  }) : super(
          mass: mass,
          radius: radius,
          cosmicVelocity: cosmicVelocity,
          isAgreed: isAgreed,
        );
}

final class MainScreenLoading extends MainScreenState {
  const MainScreenLoading({
    String? mass,
    String? radius,
    bool? isAgreed,
  }) : super(
          mass: mass,
          radius: radius,
          isAgreed: isAgreed ?? false,
          isLoading: true,
        );
}

final class MainScreenError extends MainScreenState {
  final String errorMessage;

  const MainScreenError({
    required this.errorMessage,
    String? mass,
    String? radius,
    bool? isAgreed,
  }) : super(
          mass: mass,
          radius: radius,
          isAgreed: isAgreed ?? false,
        );
}