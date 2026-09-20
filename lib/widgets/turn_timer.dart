// widgets/turn_timer.dart
// Shows the per-turn countdown bar and the player's total remaining time.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_result.dart';
import '../providers/game_provider.dart';
import '../utils/helpers.dart';

class TurnTimer extends StatelessWidget {
  const TurnTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();

    if (gp.result != GameResult.ongoing) {
      return const SizedBox(height: 48);
    }

    final t = gp.turnSecsLeft;
    final p = gp.playerSecsLeft;
    final pct = (t / kTurnSeconds).clamp(0.0, 1.0);

    // ── Turn timer colour ──────────────────────────────────────────────
    Color barColor;

    if (t <= 10) {
      barColor = const Color(0xFFE74C3C);
    } else if (t <= 20) {
      barColor = const Color(0xFFF39C12);
    } else {
      barColor = const Color(0xFF2ECC71);
    }

    // ── Player total time colour ───────────────────────────────────────
    Color playerColor;

    if (p <= 30) {
      playerColor = const Color(0xFFE74C3C);
    } else if (p <= 60) {
      playerColor = const Color(0xFFF39C12);
    } else {
      playerColor = Theme.of(context).colorScheme.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          // ── Turn countdown ───────────────────────────────────────────
          Column(
            children: [
              Text(
                'TURN',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4),
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$t',
                style: TextStyle(
                  color: barColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // ── Progress bar ─────────────────────────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: pct),
                duration: const Duration(milliseconds: 400),
                builder: (_, v, __) {
                  return LinearProgressIndicator(
                    value: v,
                    minHeight: 6,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.5),
                    valueColor: AlwaysStoppedAnimation(barColor),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Player total remaining time ─────────────────────────────
          AnimatedOpacity(
            opacity: gp.turnState == TurnState.humanTurn ? 1.0 : 0.35,
            duration: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'YOUR TIME',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatTime(p),
                  style: TextStyle(
                    color: playerColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}