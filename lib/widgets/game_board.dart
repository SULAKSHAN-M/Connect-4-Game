// widgets/game_board.dart
// Renders the 7×6 Connect 4 grid with column-tap interaction,
// hover arrows, and win-cell highlighting.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/board_constants.dart';
import '../models/cell_state.dart';
import '../models/game_result.dart';
import '../providers/game_provider.dart';
import '../themes/app_theme.dart';
import 'board_cell.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int _hoverCol = -1;

  @override
  Widget build(BuildContext context) {
    final gp      = context.watch<GameProvider>();
    final board   = gp.board;
    final winSet  = {for (final c in gp.winCells) '${c[0]}_${c[1]}'};
    final canTap  = gp.result == GameResult.ongoing &&
        gp.currentPlayer == CellState.human &&
        gp.turnState == TurnState.humanTurn;

    final colors   = Theme.of(context).extension<AppColors>()!;
    final cellSize = _cellSize(context);
    final gap      = cellSize * 0.09;

    return Container(
      decoration: BoxDecoration(
        color:        colors.boardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.45),
            blurRadius: 28,
            offset:     const Offset(0, 12),
          ),
        ],
      ),
      padding: EdgeInsets.all(gap * 1.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drop-arrow hints ──────────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(kCols, (col) {
              return _ColumnArrow(
                col:      col,
                show:     _hoverCol == col && canTap,
                cellSize: cellSize,
                gap:      gap,
                onTap:    canTap ? () => gp.humanMove(col) : null,
                onEnter:  canTap ? () => setState(() => _hoverCol = col) : null,
                onExit:   () => setState(() => _hoverCol = -1),
              );
            }),
          ),
          SizedBox(height: gap * 0.6),

          // ── Grid ──────────────────────────────────────────────────────
          for (int row = 0; row < kRows; row++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(kCols, (col) {
                final cellState = board[row][col];
                final isWin     = winSet.contains('${row}_$col');
                final isHover   = _hoverCol == col && canTap &&
                    cellState == CellState.empty;

                return GestureDetector(
                  onTap: canTap ? () => gp.humanMove(col) : null,
                  child: MouseRegion(
                    onEnter: canTap ? (_) => setState(() => _hoverCol = col) : null,
                    onExit:  (_) => setState(() => _hoverCol = -1),
                    child: Padding(
                      padding: EdgeInsets.all(gap / 2),
                      child: BoardCell(
                        state:       cellState,
                        isWin:       isWin,
                        isHoverHint: isHover,
                        size:        cellSize,
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  double _cellSize(BuildContext context) {
    final width   = MediaQuery.of(context).size.width;
    final maxCell = (width - 48 - kCols * 6) / kCols; // fit screen
    return maxCell.clamp(38.0, 58.0);
  }
}

// ── Column drop-arrow ──────────────────────────────────────────────────────────

class _ColumnArrow extends StatelessWidget {
  final int    col;
  final bool   show;
  final double cellSize;
  final double gap;
  final VoidCallback?  onTap;
  final VoidCallback?  onEnter;
  final VoidCallback   onExit;

  const _ColumnArrow({
    required this.col,
    required this.show,
    required this.cellSize,
    required this.gap,
    required this.onTap,
    required this.onEnter,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        onEnter: onEnter != null ? (_) => onEnter!() : null,
        onExit:  (_) => onExit(),
        child: SizedBox(
          width:  cellSize + gap,
          height: 26,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity:  show ? 1.0 : 0.0,
            child: const Icon(
              Icons.arrow_drop_down_rounded,
              color: AppTheme.playerRed,
              size:  26,
            ),
          ),
        ),
      ),
    );
  }
}
