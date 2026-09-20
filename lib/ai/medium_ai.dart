// ai/medium_ai.dart
// Medium difficulty: alternates between a random move and the hard strategy
// on every AI turn.
//
// Turn 0 (first AI move) → random
// Turn 1 → hard strategy
// Turn 2 → random
// …and so on.

import '../models/cell_state.dart';
import 'easy_ai.dart';
import 'hard_ai.dart';

class MediumAI {
  /// Returns a column index chosen by the medium strategy.
  ///
  /// [aiTurnIndex] is incremented by the caller after each AI move.
  /// Even index → random; odd index → hard.
  static int getMove(List<List<CellState>> board, int aiTurnIndex) {
    if (aiTurnIndex % 2 == 0) {
      return EasyAI.getMove(board);
    } else {
      return HardAI.getMove(board);
    }
  }
}
