// screens/game_screen.dart
// Main gameplay screen: board, status banner, timers, app-bar actions.

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_result.dart';
import '../providers/game_provider.dart';
import '../themes/app_theme.dart';
import '../utils/helpers.dart';
import '../widgets/game_board.dart';
import '../widgets/status_banner.dart';
import '../widgets/turn_timer.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confetti;
  bool _resultDialogShown = false;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  // ── Abort confirmation ────────────────────────────────────────────────────────
  Future<bool> _confirmAbort(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(children: [
          Text('⚠️', style: TextStyle(fontSize: 22)),
          SizedBox(width: 10),
          Text('Abort Game',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: const Text(
          'Are you sure you want to exit?\nAll progress will be lost.',
          style: TextStyle(height: 1.6),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Playing',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC0392B),
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ── Result dialog ─────────────────────────────────────────────────────────────
  void _showResultDialog(BuildContext context, GameResult r, GameProvider gp) {
    if (r == GameResult.humanWin) {
      _confetti.play();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(resultIcon(r), style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 10),
            Text(
              resultLabel(r),
              style: TextStyle(
                color:      resultColor(r, context),
                fontSize:   24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              r == GameResult.humanWin
                  ? 'Excellent play! You beat the AI.'
                  : r == GameResult.aiWin
                      ? 'The AI connected four. Try again!'
                      : 'All 42 cells filled — no winner.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:  Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(ctx);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Menu'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _resultDialogShown = false;
                    gp.startGame();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Play Again'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (_, gp, __) {
        // Trigger result dialog once per game-over event
        if (gp.result != GameResult.ongoing && !_resultDialogShown) {
          _resultDialogShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showResultDialog(context, gp.result, gp);
            }
          });
        }
        if (gp.result == GameResult.ongoing) {
          _resultDialogShown = false;
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) {
              return;
            }
            if (gp.result != GameResult.ongoing) {
              if (context.mounted) {
                Navigator.pop(context);
              }
              return;
            }
            final ok = await _confirmAbort(context);
            if (ok && context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: _buildAppBar(context, gp),
            body: Stack(
              children: [
                _buildBody(context, gp),
                // Confetti for human win
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confetti,
                    blastDirectionality: BlastDirectionality.explosive,
                    numberOfParticles:   30,
                    gravity:             0.3,
                    colors: const [
                      Color(0xFFE53935),
                      Color(0xFFFDD835),
                      Color(0xFF7C4DFF),
                      Color(0xFF2ECC71),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, GameProvider gp) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          _StatBadge(label: 'W', value: gp.stats.wins,   color: const Color(0xFF2ECC71)),
          const SizedBox(width: 6),
          _StatBadge(label: 'D', value: gp.stats.draws,  color: const Color(0xFF8899BB)),
          const SizedBox(width: 6),
          _StatBadge(label: 'L', value: gp.stats.losses, color: const Color(0xFFE74C3C)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:        Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
            ),
            child: Text(
              gp.difficulty.name.toUpperCase(),
              style: TextStyle(
                color:       Theme.of(context).colorScheme.primary,
                fontSize:    11,
                fontWeight:  FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Undo button
        IconButton(
          icon: Icon(
            Icons.undo_rounded,
            color: gp.canUndo
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          tooltip:   'Undo',
          onPressed: gp.canUndo ? gp.undoMove : null,
        ),
        // Restart
        IconButton(
          icon:    const Icon(Icons.refresh_rounded),
          tooltip: 'Restart',
          onPressed: () {
            gp.startGame();
            setState(() => _resultDialogShown = false);
          },
        ),
        // Exit
        IconButton(
          icon:    const Icon(Icons.close_rounded),
          tooltip: 'Exit',
          onPressed: () async {
            if (gp.result != GameResult.ongoing) { Navigator.pop(context); return; }
            final ok = await _confirmAbort(context);
            if (ok && context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody(BuildContext context, GameProvider gp) {
    return Column(
      children: [
        // Status message
        const StatusBanner(),

        // Timer bar
        const TurnTimer(),

        // Board
        const Expanded(
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: GameBoard(),
            ),
          ),
        ),

        // Legend
        _buildLegend(context),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(color: AppTheme.playerRed,  label: 'You'),
        SizedBox(width: 20),
        _LegendDot(color: AppTheme.aiYellow,   label: 'AI'),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int    value;
  final Color  color;
  const _StatBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color:        Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Row(children: [
          Text('$label ',
              style: TextStyle(
                  color:    Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                  fontSize: 11)),
          Text('$value',
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ]),
      );
}

class _LegendDot extends StatelessWidget {
  final Color  color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width:  13, height: 13,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                color:    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                fontSize: 12)),
      ]);
}
