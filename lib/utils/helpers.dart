// utils/helpers.dart
// Small stateless utility functions used across the UI layer.

import 'package:flutter/material.dart';
import '../models/game_result.dart';

/// Formats seconds as m:ss (e.g. 3:07).
String formatTime(int totalSeconds) {
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// Returns a human-readable label for [result].
String resultLabel(GameResult result) {
  switch (result) {
    case GameResult.humanWin: return 'You Win! 🏆';
    case GameResult.aiWin:    return 'AI Wins 💀';
    case GameResult.draw:     return 'Draw 🤝';
    case GameResult.ongoing:  return '';
  }
}

/// Returns an emoji icon for [result].
String resultIcon(GameResult result) {
  switch (result) {
    case GameResult.humanWin: return '🏆';
    case GameResult.aiWin:    return '💀';
    case GameResult.draw:     return '🤝';
    case GameResult.ongoing:  return '🎮';
  }
}

/// Returns the accent colour for a win/loss/draw result.
Color resultColor(GameResult result, BuildContext context) {
  switch (result) {
    case GameResult.humanWin: return const Color(0xFF2ECC71);
    case GameResult.aiWin:    return const Color(0xFFE74C3C);
    case GameResult.draw:     return const Color(0xFFF39C12);
    case GameResult.ongoing:  return Theme.of(context).colorScheme.primary;
  }
}
