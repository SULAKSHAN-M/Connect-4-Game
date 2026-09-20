// logic/game_logic.dart
// Pure, stateless game-logic functions.
// No Flutter imports — 100% unit-testable in isolation.

import '../models/cell_state.dart';
import '../models/game_move.dart';
import '../models/game_result.dart';
import 'board_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Board factory
// ─────────────────────────────────────────────────────────────────────────────

/// Returns a fresh empty 6×7 board.
List<List<CellState>> emptyBoard() =>
    List.generate(kRows, (_) => List.filled(kCols, CellState.empty));

/// Deep-copies a board without mutating the original.
List<List<CellState>> copyBoard(List<List<CellState>> board) =>
    [for (final row in board) List<CellState>.from(row)];

// ─────────────────────────────────────────────────────────────────────────────
// Move validation
// ─────────────────────────────────────────────────────────────────────────────

/// Returns true when [column] is within bounds and not full.
bool isValidMove(List<List<CellState>> board, int column) {
  if (column < 0 || column >= kCols) {
    return false;
  }

  return board[0][column] == CellState.empty;
}

/// Returns all column indices that currently accept a disc.
List<int> getAvailableColumns(List<List<CellState>> board) =>
    [for (int c = 0; c < kCols; c++) if (isValidMove(board, c)) c];

/// Returns the lowest empty row index in [column],
/// or -1 if the column is full.
int getAvailableRow(List<List<CellState>> board, int column) {
  for (int r = kRows - 1; r >= 0; r--) {
    if (board[r][column] == CellState.empty) {
      return r;
    }
  }

  return -1;
}

// ─────────────────────────────────────────────────────────────────────────────
// Applying / undoing moves
// ─────────────────────────────────────────────────────────────────────────────

/// Places [player]'s disc in [column] and returns the new board.
/// Does NOT mutate the original board.
/// Returns null if the column is full.
List<List<CellState>>? applyMove(
  List<List<CellState>> board,
  int column,
  CellState player,
) {
  final row = getAvailableRow(board, column);

  if (row == -1) {
    return null;
  }

  final newBoard = copyBoard(board);
  newBoard[row][column] = player;

  return newBoard;
}

/// Returns the board state before [move] was made.
/// Does NOT mutate the original board.
List<List<CellState>> undoMove(
  List<List<CellState>> board,
  GameMove move,
) {
  final newBoard = copyBoard(board);
  newBoard[move.row][move.column] = CellState.empty;

  return newBoard;
}

// ─────────────────────────────────────────────────────────────────────────────
// Win detection
// ─────────────────────────────────────────────────────────────────────────────

/// Returns the 4 winning [row, col] pairs if [player] has won,
/// or null otherwise.
List<List<int>>? checkWinner(
  List<List<CellState>> board,
  CellState player,
) {
  const directions = [
    [0, 1],   // horizontal →
    [1, 0],   // vertical ↓
    [1, 1],   // diagonal ↘
    [1, -1],  // anti-diagonal ↙
  ];

  for (int r = 0; r < kRows; r++) {
    for (int c = 0; c < kCols; c++) {
      if (board[r][c] != player) {
        continue;
      }

      for (final dir in directions) {
        final cells = <List<int>>[[r, c]];

        for (int k = 1; k < kWinLength; k++) {
          final nr = r + dir[0] * k;
          final nc = c + dir[1] * k;

          if (
              nr < 0 ||
              nr >= kRows ||
              nc < 0 ||
              nc >= kCols) {
            break;
          }

          if (board[nr][nc] != player) {
            break;
          }

          cells.add([nr, nc]);
        }

        if (cells.length == kWinLength) {
          return cells;
        }
      }
    }
  }

  return null;
}

/// Returns true when either player has won.
bool hasWinner(List<List<CellState>> board) {
  return checkWinner(board, CellState.human) != null ||
      checkWinner(board, CellState.ai) != null;
}

/// Returns true when the board is completely full.
bool checkDraw(List<List<CellState>> board) {
  return board[0].every((c) => c != CellState.empty);
}

/// Evaluates the current game state.
GameResult evaluateResult(List<List<CellState>> board) {
  if (checkWinner(board, CellState.human) != null) {
    return GameResult.humanWin;
  }

  if (checkWinner(board, CellState.ai) != null) {
    return GameResult.aiWin;
  }

  if (checkDraw(board)) {
    return GameResult.draw;
  }

  return GameResult.ongoing;
}