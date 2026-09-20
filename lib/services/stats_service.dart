// services/stats_service.dart
// Handles all shared_preferences reads and writes for game statistics
// and app settings (difficulty, dark mode).

import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_stats.dart';
import '../models/difficulty.dart';

class StatsService {
  // ── Storage keys ────────────────────────────────────────────────────────────
  static const _kWins       = 'c4_wins';
  static const _kLosses     = 'c4_losses';
  static const _kDraws      = 'c4_draws';
  static const _kDifficulty = 'c4_difficulty';
  static const _kDarkMode   = 'c4_dark_mode';

  // ── Statistics ───────────────────────────────────────────────────────────────

  /// Loads persisted statistics. Returns zeros on first run.
  static Future<GameStats> loadStats() async {
    final p = await SharedPreferences.getInstance();
    return GameStats(
      wins:   p.getInt(_kWins)   ?? 0,
      losses: p.getInt(_kLosses) ?? 0,
      draws:  p.getInt(_kDraws)  ?? 0,
    );
  }

  /// Persists the full [GameStats] object.
  static Future<void> saveStats(GameStats s) async {
    final p = await SharedPreferences.getInstance();
    await Future.wait([
      p.setInt(_kWins,   s.wins),
      p.setInt(_kLosses, s.losses),
      p.setInt(_kDraws,  s.draws),
    ]);
  }

  /// Increments wins by 1 and saves.
  static Future<GameStats> recordWin(GameStats current) async {
    final updated = current.copyWith(wins: current.wins + 1);
    await saveStats(updated);
    return updated;
  }

  /// Increments losses by 1 and saves.
  static Future<GameStats> recordLoss(GameStats current) async {
    final updated = current.copyWith(losses: current.losses + 1);
    await saveStats(updated);
    return updated;
  }

  /// Increments draws by 1 and saves.
  static Future<GameStats> recordDraw(GameStats current) async {
    final updated = current.copyWith(draws: current.draws + 1);
    await saveStats(updated);
    return updated;
  }

  /// Clears all statistics from storage.
  static Future<GameStats> resetStats() async {
    const zero = GameStats();
    await saveStats(zero);
    return zero;
  }

  // ── Settings ─────────────────────────────────────────────────────────────────

  /// Loads the persisted difficulty. Defaults to [Difficulty.easy].
  static Future<Difficulty> loadDifficulty() async {
    final p     = await SharedPreferences.getInstance();
    final index = p.getInt(_kDifficulty) ?? 0;
    return Difficulty.values[index.clamp(0, Difficulty.values.length - 1)];
  }

  /// Persists the selected [Difficulty].
  static Future<void> saveDifficulty(Difficulty d) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kDifficulty, d.index);
  }

  /// Loads the persisted dark-mode flag. Defaults to true.
  static Future<bool> loadDarkMode() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kDarkMode) ?? true;
  }

  /// Persists the dark-mode flag.
  static Future<void> saveDarkMode(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kDarkMode, value);
  }
}
