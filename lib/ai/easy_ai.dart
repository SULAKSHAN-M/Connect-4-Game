// ai/easy_ai.dart
// Easy difficulty: chooses a uniformly random legal move every turn.

import 'dart:math';
import '../logic/game_logic.dart';
import '../models/cell_state.dart';

class EasyAI {
  static final Random _rng = Random();

  /// Returns a random legal column index, or -1 if no moves are available.
  static int getMove(List<List<CellState>> board) {
    final cols = getAvailableColumns(board);
    if (cols.isEmpty) {
      return -1;
    }
    return cols[_rng.nextInt(cols.length)];
  }
}
