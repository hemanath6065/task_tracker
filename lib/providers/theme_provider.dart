import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _hasSeenOnboarding = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  ThemeNotifier() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    _hasSeenOnboarding = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', false);
    notifyListeners();
  }
}
