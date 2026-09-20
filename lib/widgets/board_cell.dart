// widgets/board_cell.dart
// Renders a single Connect 4 cell with drop animation and win-pulse effect.

import 'package:flutter/material.dart';
import '../models/cell_state.dart';
import '../themes/app_theme.dart';

class BoardCell extends StatefulWidget {
  final CellState state;
  final bool      isWin;
  final bool      isHoverHint;
  final double    size;

  const BoardCell({
    super.key,
    required this.state,
    this.isWin       = false,
    this.isHoverHint = false,
    this.size        = 50,
  });

  @override
  State<BoardCell> createState() => _BoardCellState();
}

class _BoardCellState extends State<BoardCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _scaleAnim;
  CellState _prevState = CellState.empty;

  @override
  void initState() {
    super.initState();
    _ctrl      = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _prevState = widget.state;
    if (widget.state != CellState.empty) {
      _ctrl.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(BoardCell old) {
    super.didUpdateWidget(old);
    if (widget.state != CellState.empty && _prevState == CellState.empty) {
      _ctrl.forward(from: 0);
    }
    _prevState = widget.state;
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Color _fill(BuildContext ctx) {
    final colors = Theme.of(ctx).extension<AppColors>()!;
    if (widget.isHoverHint) {
      return AppTheme.playerRed.withValues(alpha: 0.18);
    }
    switch (widget.state) {
      case CellState.human: return AppTheme.playerRed;
      case CellState.ai:    return AppTheme.aiYellow;
      case CellState.empty: return colors.cellEmpty;
    }
  }

  Color _border(BuildContext ctx) {
    if (widget.isHoverHint) {
      return AppTheme.playerRed.withValues(alpha: 0.5);
    }
    switch (widget.state) {
      case CellState.human: return AppTheme.playerRed.withValues(alpha: 0.7);
      case CellState.ai:    return AppTheme.aiYellow.withValues(alpha: 0.7);
      case CellState.empty: return Colors.black.withValues(alpha: 0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget disc = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width:  widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape:  BoxShape.circle,
        color:  _fill(context),
        border: Border.all(color: _border(context), width: 2),
        boxShadow: widget.isWin
            ? [
                BoxShadow(
                  color: (widget.state == CellState.human
                          ? AppTheme.playerRed
                          : AppTheme.aiYellow)
                      .withValues(alpha: 0.7),
                  blurRadius: 14,
                  spreadRadius: 3,
                ),
              ]
            : widget.state != CellState.empty
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
      ),
      child: widget.state != CellState.empty
          ? Align(
              alignment: const Alignment(-0.3, -0.35),
              child: Container(
                width:  widget.size * 0.22,
                height: widget.size * 0.15,
                decoration: BoxDecoration(
                  color:        Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(widget.size),
                ),
              ),
            )
          : null,
    );

    // Drop-in scale animation
    if (widget.state != CellState.empty) {
      disc = ScaleTransition(scale: _scaleAnim, child: disc);
    }

    // Pulsing glow for winning cells
    if (widget.isWin) {
      disc = _WinPulse(child: disc);
    }

    return disc;
  }
}

// ── Looping pulse animation for winning discs ─────────────────────────────────

class _WinPulse extends StatefulWidget {
  final Widget child;
  const _WinPulse({required this.child});
  @override
  State<_WinPulse> createState() => _WinPulseState();
}

class _WinPulseState extends State<_WinPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 1.0, end: 1.15)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(scale: _anim, child: widget.child);
}
