import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
  factory SharedPreferencesHelper() => _instance;
  SharedPreferencesHelper._internal();

  static const String _lastMassKey = 'last_mass';
  static const String _lastRadiusKey = 'last_radius';
  static const String _lastAgreementKey = 'last_agreement';
  static const String _calculationCountKey = 'calculation_count';

  Future<void> saveLastInput({
    required String mass,
    required String radius,
    required bool isAgreed,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastMassKey, mass);
    await prefs.setString(_lastRadiusKey, radius);
    await prefs.setBool(_lastAgreementKey, isAgreed);
  }

  Future<Map<String, dynamic>> getLastInput() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'mass': prefs.getString(_lastMassKey) ?? '',
      'radius': prefs.getString(_lastRadiusKey) ?? '',
      'isAgreed': prefs.getBool(_lastAgreementKey) ?? false,
    };
  }

  Future<void> incrementCalculationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_calculationCountKey) ?? 0;
    await prefs.setInt(_calculationCountKey, currentCount + 1);
  }

  Future<int> getCalculationCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_calculationCountKey) ?? 0;
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}