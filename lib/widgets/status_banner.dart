// widgets/status_banner.dart
// Animated status message bar shown above the board during gameplay.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cell_state.dart';
import '../models/game_result.dart';
import '../providers/game_provider.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();

    String msg;
    Color  color;
    double size = 15;

    if (gp.showingStart) {
      msg   = 'GAME STARTED';
      color = const Color(0xFF2ECC71);
      size  = 20;
    } else if (gp.result == GameResult.humanWin) {
      msg   = '🏆  YOU WIN!';
      color = const Color(0xFF2ECC71);
      size  = 20;
    } else if (gp.result == GameResult.aiWin) {
      msg   = '💀  AI WINS';
      color = const Color(0xFFE74C3C);
      size  = 20;
    } else if (gp.result == GameResult.draw) {
      msg   = '🤝  DRAW';
      color = const Color(0xFFF39C12);
      size  = 20;
    } else if (gp.turnState == TurnState.aiThinking) {
      msg   = 'AI IS THINKING...';
      color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    } else if (gp.currentPlayer == CellState.human) {
      msg   = "IT'S YOUR TURN";
      color = const Color(0xFFF1C40F);
    } else {
      msg   = 'AI IS THINKING...';
      color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      child: Padding(
        key:     ValueKey(msg),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:      color,
            fontSize:   size,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
