// themes/theme_provider.dart
// Manages dark/light theme state and persists the preference.

import 'package:flutter/foundation.dart';
import '../services/stats_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  Future<void> init() async {
    _isDark = await StatsService.loadDarkMode();
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    await StatsService.saveDarkMode(_isDark);
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    if (_isDark == value) {
      return;
    }
    _isDark = value;
    await StatsService.saveDarkMode(_isDark);
    notifyListeners();
  }
}
