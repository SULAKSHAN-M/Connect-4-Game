// models/game_move.dart
// A single move recorded in the move-history stack (used for undo).

import 'cell_state.dart';

class GameMove {
  final int column;
  final int row;
  final CellState player;

  const GameMove({
    required this.column,
    required this.row,
    required this.player,
  });

  @override
  String toString() => 'GameMove(col: $column, row: $row, player: $player)';
}
