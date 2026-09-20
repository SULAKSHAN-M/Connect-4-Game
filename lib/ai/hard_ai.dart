// ai/hard_ai.dart
// Hard difficulty: implements the six-step rule-based strategy.
//
// Priority order:
//   1. Win immediately if possible.
//   2. Block the opponent's immediate win.
//   3. Create a three-in-a-row with an open end.
//   4. Prefer the centre column.
//   5. Prefer columns adjacent to the centre.
//   6. Any remaining legal column.

import '../logic/game_logic.dart';
import '../logic/board_constants.dart';
import '../models/cell_state.dart';
import 'easy_ai.dart';

class HardAI {
  /// Returns the best column according to the six-step strategy.
  static int getMove(List<List<CellState>> board) {
    final cols = getAvailableColumns(board);

    if (cols.isEmpty) {
      return -1;
    }

    // 1. Win immediately.
    for (final col in cols) {
      final b = applyMove(board, col, CellState.ai);

      if (b != null && checkWinner(b, CellState.ai) != null) {
        return col;
      }
    }

    // 2. Block opponent's winning move.
    for (final col in cols) {
      final b = applyMove(board, col, CellState.human);

      if (b != null && checkWinner(b, CellState.human) != null) {
        return col;
      }
    }

    // 3. Create a three-in-a-row with an open end.
    for (final col in cols) {
      final b = applyMove(board, col, CellState.ai);

      if (b != null && _hasThreeWithOpenEnd(b, CellState.ai)) {
        return col;
      }
    }

    // 4. Centre column.
    const centre = kCols ~/ 2;

    if (cols.contains(centre)) {
      return centre;
    }

    // 5. Columns adjacent to centre.
    for (final adj in [
      centre - 1,
      centre + 1,
      centre - 2,
      centre + 2,
    ]) {
      if (cols.contains(adj)) {
        return adj;
      }
    }

    // 6. Any legal column.
    return EasyAI.getMove(board);
  }

  // ───────────────────────────────────────────────────────────────────────────

  /// Returns true if [board] contains a run of 3 or more [player] discs
  /// with at least one open end.
  static bool _hasThreeWithOpenEnd(
    List<List<CellState>> board,
    CellState player,
  ) {
    const dirs = [
      [0, 1],   // horizontal
      [1, 0],   // vertical
      [1, 1],   // diagonal
      [1, -1],  // anti-diagonal
    ];

    for (int r = 0; r < kRows; r++) {
      for (int c = 0; c < kCols; c++) {
        if (board[r][c] != player) {
          continue;
        }

        for (final d in dirs) {
          int count = 1;
          int openEnds = 0;

          // Extend forward
          int nr = r + d[0];
          int nc = c + d[1];

          while (
              nr >= 0 &&
              nr < kRows &&
              nc >= 0 &&
              nc < kCols &&
              board[nr][nc] == player) {
            count++;
            nr += d[0];
            nc += d[1];
          }

          if (
              nr >= 0 &&
              nr < kRows &&
              nc >= 0 &&
              nc < kCols &&
              board[nr][nc] == CellState.empty) {
            openEnds++;
          }

          // Extend backward
          nr = r - d[0];
          nc = c - d[1];

          while (
              nr >= 0 &&
              nr < kRows &&
              nc >= 0 &&
              nc < kCols &&
              board[nr][nc] == player) {
            count++;
            nr -= d[0];
            nc -= d[1];
          }

          if (
              nr >= 0 &&
              nr < kRows &&
              nc >= 0 &&
              nc < kCols &&
              board[nr][nc] == CellState.empty) {
            openEnds++;
          }

          if (count >= 3 && openEnds >= 1) {
            return true;
          }
        }
      }
    }

    return false;
  }
}