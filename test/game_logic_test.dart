// test/game_logic_test.dart
// Unit tests for the pure game-logic functions in lib/logic/game_logic.dart
// and the AI modules in lib/ai/.
//
// Run with:  flutter test
//
// No widget or integration tests — only pure Dart function tests.

import 'package:flutter_test/flutter_test.dart';
import 'package:connect4/logic/game_logic.dart';
import 'package:connect4/logic/board_constants.dart';
import 'package:connect4/models/cell_state.dart';
import 'package:connect4/models/game_move.dart';
import 'package:connect4/models/game_result.dart';
import 'package:connect4/ai/easy_ai.dart';
import 'package:connect4/ai/hard_ai.dart';
import 'package:connect4/ai/medium_ai.dart';

// ── Helper shortcuts ──────────────────────────────────────────────────────────

List<List<CellState>> blank() => emptyBoard();

/// Drop a disc of [player] into [col] on [board] and return the new board.
List<List<CellState>> drop(
    List<List<CellState>> board, int col, CellState player) {
  return applyMove(board, col, player)!;
}

void main() {
  // ══════════════════════════════════════════════════════════════════════════════
  // isValidMove
  // ══════════════════════════════════════════════════════════════════════════════
  group('isValidMove()', () {
    test('vM1 – empty column is valid', () {
      expect(isValidMove(blank(), 0), isTrue);
    });

    test('vM2 – full column is invalid', () {
      var b = blank();
      for (int i = 0; i < kRows; i++) {
        b = drop(b, 0, CellState.human);
      }
      expect(isValidMove(b, 0), isFalse);
    });

    test('vM3 – column index -1 is invalid', () {
      expect(isValidMove(blank(), -1), isFalse);
    });

    test('vM4 – column index == kCols is invalid', () {
      expect(isValidMove(blank(), kCols), isFalse);
    });

    test('vM5 – partially filled column is valid', () {
      var b = blank();
      b = drop(b, 3, CellState.human);
      b = drop(b, 3, CellState.ai);
      expect(isValidMove(b, 3), isTrue);
    });

    test('vM6 – all other columns valid when one is full', () {
      var b = blank();
      for (int i = 0; i < kRows; i++) {
        b = drop(b, 0, CellState.human);
      }
      for (int c = 1; c < kCols; c++) {
        expect(isValidMove(b, c), isTrue);
      }
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // getAvailableRow
  // ══════════════════════════════════════════════════════════════════════════════
  group('getAvailableRow()', () {
    test('gR1 – empty column returns bottom row', () {
      expect(getAvailableRow(blank(), 0), equals(kRows - 1));
    });

    test('gR2 – one disc → row kRows-2', () {
      var b = blank();
      b = drop(b, 0, CellState.human);
      expect(getAvailableRow(b, 0), equals(kRows - 2));
    });

    test('gR3 – full column returns -1', () {
      var b = blank();
      for (int i = 0; i < kRows; i++) {
        b = drop(b, 0, CellState.human);
      }
      expect(getAvailableRow(b, 0), equals(-1));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // applyMove
  // ══════════════════════════════════════════════════════════════════════════════
  group('applyMove()', () {
    test('aM1 – disc placed at correct row', () {
      final b = drop(blank(), 0, CellState.human);
      expect(b[kRows - 1][0], equals(CellState.human));
    });

    test('aM2 – discs stack in correct order', () {
      var b = blank();
      b = drop(b, 0, CellState.human);
      b = drop(b, 0, CellState.ai);
      expect(b[kRows - 2][0], equals(CellState.ai));
    });

    test('aM3 – applyMove returns null for full column', () {
      var b = blank();
      for (int i = 0; i < kRows; i++) {
        b = drop(b, 0, CellState.human);
      }
      expect(applyMove(b, 0, CellState.ai), isNull);
    });

    test('aM4 – original board is not mutated', () {
      final original = blank();
      applyMove(original, 3, CellState.human);
      expect(original[kRows - 1][3], equals(CellState.empty));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // undoMove
  // ══════════════════════════════════════════════════════════════════════════════
  group('undoMove()', () {
    test('uM1 – cell reverts to empty after undo', () {
      var b = blank();
      b = drop(b, 3, CellState.human);
      const move = GameMove(column: 3, row: kRows - 1, player: CellState.human);
      b = undoMove(b, move);
      expect(b[kRows - 1][3], equals(CellState.empty));
    });

    test('uM2 – undoing stacked disc exposes lower disc', () {
      var b = blank();
      b = drop(b, 2, CellState.human); // row 5
      b = drop(b, 2, CellState.ai);   // row 4
      const move = GameMove(column: 2, row: kRows - 2, player: CellState.ai);
      b = undoMove(b, move);
      expect(b[kRows - 2][2], equals(CellState.empty));
      expect(b[kRows - 1][2], equals(CellState.human)); // lower still present
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // checkWinner
  // ══════════════════════════════════════════════════════════════════════════════
  group('checkWinner()', () {
    test('cW1 – no winner on empty board', () {
      expect(checkWinner(blank(), CellState.human), isNull);
    });

    test('cW2 – horizontal win (cols 0–3)', () {
      var b = blank();
      for (int c = 0; c < 4; c++) {
        b = drop(b, c, CellState.human);
      }
      expect(checkWinner(b, CellState.human), isNotNull);
    });

    test('cW3 – horizontal win at right edge (cols 3–6)', () {
      var b = blank();
      for (int c = 3; c < 7; c++) {
        b = drop(b, c, CellState.human);
      }
      expect(checkWinner(b, CellState.human), isNotNull);
    });

    test('cW4 – vertical win (4 in col 0)', () {
      var b = blank();
      for (int i = 0; i < 4; i++) {
        b = drop(b, 0, CellState.human);
      }
      expect(checkWinner(b, CellState.human), isNotNull);
    });

    test('cW5 – diagonal win ↘', () {
      var b = blank();
      for (int col = 0; col < 4; col++) {
        for (int pad = 0; pad < col; pad++) {
          b = drop(b, col, CellState.ai);
        }
        b = drop(b, col, CellState.human);
      }
      expect(checkWinner(b, CellState.human), isNotNull);
    });

    test('cW6 – anti-diagonal win ↙', () {
      var b = blank();
      for (int col = 3; col >= 0; col--) {
        for (int pad = 0; pad < (3 - col); pad++) {
          b = drop(b, col, CellState.ai);
        }
        b = drop(b, col, CellState.human);
      }
      expect(checkWinner(b, CellState.human), isNotNull);
    });

    test('cW7 – three-in-a-row is NOT a win', () {
      var b = blank();
      for (int c = 0; c < 3; c++) {
        b = drop(b, c, CellState.human);
      }
      expect(checkWinner(b, CellState.human), isNull);
    });

    test('cW8 – winning cells list has exactly 4 entries', () {
      var b = blank();
      for (int c = 0; c < 4; c++) {
        b = drop(b, c, CellState.human);
      }
      expect(checkWinner(b, CellState.human)?.length, equals(4));
    });

    test('cW9 – opponent win not confused with player win', () {
      var b = blank();
      for (int c = 0; c < 4; c++) {
        b = drop(b, c, CellState.ai);
      }
      expect(checkWinner(b, CellState.human), isNull);
      expect(checkWinner(b, CellState.ai),    isNotNull);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // checkDraw
  // ══════════════════════════════════════════════════════════════════════════════
  group('checkDraw()', () {
    test('dR1 – empty board is not a draw', () {
      expect(checkDraw(blank()), isFalse);
    });

    test('dR2 – partially filled board is not a draw', () {
      var b = blank();
      b = drop(b, 0, CellState.human);
      expect(checkDraw(b), isFalse);
    });

    test('dR3 – fully filled board is a draw', () {
      var b = blank();
      // Fill every column to the brim alternating players
      for (int c = 0; c < kCols; c++) {
        for (int r = 0; r < kRows; r++) {
          b[r][c] = (r + c) % 2 == 0 ? CellState.human : CellState.ai;
        }
      }
      expect(checkDraw(b), isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // evaluateResult
  // ══════════════════════════════════════════════════════════════════════════════
  group('evaluateResult()', () {
    test('eR1 – empty board is ongoing', () {
      expect(evaluateResult(blank()), equals(GameResult.ongoing));
    });

    test('eR2 – human win detected', () {
      var b = blank();
      for (int c = 0; c < 4; c++) {
        b = drop(b, c, CellState.human);
      }
      expect(evaluateResult(b), equals(GameResult.humanWin));
    });

    test('eR3 – AI win detected', () {
      var b = blank();
      for (int c = 0; c < 4; c++) {
        b = drop(b, c, CellState.ai);
      }
      expect(evaluateResult(b), equals(GameResult.aiWin));
    });

test('eR4 – draw detected on full board', () {
  final b = [
    [
      CellState.human,
      CellState.human,
      CellState.ai,
      CellState.ai,
      CellState.human,
      CellState.human,
      CellState.ai,
    ],
    [
      CellState.ai,
      CellState.ai,
      CellState.human,
      CellState.human,
      CellState.ai,
      CellState.ai,
      CellState.human,
    ],
    [
      CellState.human,
      CellState.human,
      CellState.ai,
      CellState.ai,
      CellState.human,
      CellState.human,
      CellState.ai,
    ],
    [
      CellState.ai,
      CellState.ai,
      CellState.human,
      CellState.human,
      CellState.ai,
      CellState.ai,
      CellState.human,
    ],
    [
      CellState.human,
      CellState.human,
      CellState.ai,
      CellState.ai,
      CellState.human,
      CellState.human,
      CellState.ai,
    ],
    [
      CellState.ai,
      CellState.ai,
      CellState.human,
      CellState.human,
      CellState.ai,
      CellState.ai,
      CellState.human,
    ],
  ];

  expect(checkWinner(b, CellState.human), isNull);
  expect(checkWinner(b, CellState.ai), isNull);
  expect(checkDraw(b), isTrue);
  expect(evaluateResult(b), equals(GameResult.draw));
  });
    });

  // ══════════════════════════════════════════════════════════════════════════════
  // getAvailableColumns
  // ══════════════════════════════════════════════════════════════════════════════
  group('getAvailableColumns()', () {
    test('aC1 – all 7 columns available on empty board', () {
      expect(getAvailableColumns(blank()).length, equals(kCols));
    });

    test('aC2 – 6 columns after one is filled', () {
      var b = blank();
      for (int i = 0; i < kRows; i++) {
        b = drop(b, 0, CellState.human);
      }
      expect(getAvailableColumns(b).length, equals(kCols - 1));
      expect(getAvailableColumns(b).contains(0), isFalse);
    });

    test('aC3 – empty list when board is completely full', () {
      var b = blank();
      for (int c = 0; c < kCols; c++) {
        for (int r = 0; r < kRows; r++) {
          b[r][c] = CellState.human;
        }
      }
      expect(getAvailableColumns(b), isEmpty);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // EasyAI
  // ══════════════════════════════════════════════════════════════════════════════
  group('EasyAI.getMove()', () {
    test('eA1 – returns a valid column on empty board', () {
      final col = EasyAI.getMove(blank());
      expect(col, inInclusiveRange(0, kCols - 1));
    });

    test('eA2 – returns -1 when board is full', () {
      var b = blank();
      for (int c = 0; c < kCols; c++) {
        for (int r = 0; r < kRows; r++) {
          b[r][c] = CellState.human;
        }
      }
      expect(EasyAI.getMove(b), equals(-1));
    });

    test('eA3 – chosen column is always legal', () {
      var b = blank();
      // Fill 5 of 7 columns
      for (int c = 0; c < 5; c++) {
        for (int r = 0; r < kRows; r++) {
          b[r][c] = CellState.human;
        }
      }
      final col = EasyAI.getMove(b);
      expect(col >= 5, isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // HardAI
  // ══════════════════════════════════════════════════════════════════════════════
  group('HardAI.getMove()', () {
    test('hA1 – AI takes immediate win', () {
      var b = blank();
      b = drop(b, 0, CellState.ai);
      b = drop(b, 1, CellState.ai);
      b = drop(b, 2, CellState.ai);
      expect(HardAI.getMove(b), equals(3));
    });

    test('hA2 – AI blocks human horizontal win', () {
      var b = blank();
      b = drop(b, 0, CellState.human);
      b = drop(b, 1, CellState.human);
      b = drop(b, 2, CellState.human);
      expect(HardAI.getMove(b), equals(3));
    });

    test('hA3 – AI prefers centre on empty board', () {
      expect(HardAI.getMove(blank()), equals(3));
    });

    test('hA4 – AI wins vertically instead of non-winning move', () {
      var b = blank();
      b = drop(b, 4, CellState.ai);
      b = drop(b, 4, CellState.ai);
      b = drop(b, 4, CellState.ai);
      expect(HardAI.getMove(b), equals(4)); // winning vertical move
    });

    test('hA5 – AI blocks human vertical win', () {
      var b = blank();
      b = drop(b, 5, CellState.human);
      b = drop(b, 5, CellState.human);
      b = drop(b, 5, CellState.human);
      expect(HardAI.getMove(b), equals(5));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════════
  // MediumAI
  // ══════════════════════════════════════════════════════════════════════════════
  group('MediumAI.getMove()', () {
    test('mA1 – turn index 0 returns a legal column (random path)', () {
      final col = MediumAI.getMove(blank(), 0);
      expect(isValidMove(blank(), col), isTrue);
    });

    test('mA2 – even turn index uses random path', () {
      // On an empty board the random path also returns a valid column
      final col = MediumAI.getMove(blank(), 2);
      expect(col, inInclusiveRange(0, kCols - 1));
    });

    test('mA3 – odd turn index uses hard path (wins immediately)', () {
      var b = blank();
      b = drop(b, 0, CellState.ai);
      b = drop(b, 1, CellState.ai);
      b = drop(b, 2, CellState.ai);
      // Turn index 1 → hard path → should win at col 3
      expect(MediumAI.getMove(b, 1), equals(3));
    });
  });
}
