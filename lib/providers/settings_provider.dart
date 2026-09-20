// providers/settings_provider.dart
// Manages difficulty and first-player preference with persistence.

import 'package:flutter/foundation.dart';
import '../models/difficulty.dart';
import '../services/stats_service.dart';

class SettingsProvider extends ChangeNotifier {
  Difficulty _difficulty  = Difficulty.easy;
  String     _firstPref   = 'random';

  Difficulty get difficulty => _difficulty;
  String     get firstPref  => _firstPref;

  Future<void> init() async {
    _difficulty = await StatsService.loadDifficulty();
    notifyListeners();
  }

  Future<void> setDifficulty(Difficulty d) async {
    _difficulty = d;
    await StatsService.saveDifficulty(d);
    notifyListeners();
  }

  void setFirstPref(String v) {
    _firstPref = v;
    notifyListeners();
  }
}
