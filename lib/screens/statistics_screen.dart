// screens/statistics_screen.dart
// Displays persistent win/loss/draw statistics with a simple visual breakdown.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/stat_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp    = context.watch<GameProvider>();
    final stats = gp.stats;

    return Scaffold(
      appBar: AppBar(title: const Text('STATISTICS')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Score row ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatCard(label: 'WINS',   value: stats.wins,   color: const Color(0xFF2ECC71)),
                StatCard(label: 'DRAWS',  value: stats.draws,  color: const Color(0xFF8899BB)),
                StatCard(label: 'LOSSES', value: stats.losses, color: const Color(0xFFE74C3C)),
              ],
            )
                .animate()
                .fadeIn(duration: 450.ms)
                .slideY(begin: 0.2, duration: 450.ms),
            const SizedBox(height: 28),

            // ── Summary card ─────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SUMMARY',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.45),
                            fontSize:    11,
                            letterSpacing: 3,
                            fontWeight:  FontWeight.w600)),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: 'Total Games Played',
                      value: '${stats.totalGames}',
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Win Rate',
                      value: '${stats.winRate.toStringAsFixed(1)} %',
                      color: const Color(0xFF2ECC71),
                    ),
                  ],
                ),
              ),
            )
                .animate(delay: 150.ms)
                .fadeIn(duration: 450.ms),
            const SizedBox(height: 20),

            // ── Bar chart ────────────────────────────────────────────
            if (stats.totalGames > 0) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BREAKDOWN',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.45),
                              fontSize:    11,
                              letterSpacing: 3,
                              fontWeight:  FontWeight.w600)),
                      const SizedBox(height: 16),
                      _Bar(
                          label: 'Wins',
                          count: stats.wins,
                          total: stats.totalGames,
                          color: const Color(0xFF2ECC71)),
                      const SizedBox(height: 10),
                      _Bar(
                          label: 'Losses',
                          count: stats.losses,
                          total: stats.totalGames,
                          color: const Color(0xFFE74C3C)),
                      const SizedBox(height: 10),
                      _Bar(
                          label: 'Draws',
                          count: stats.draws,
                          total: stats.totalGames,
                          color: const Color(0xFF8899BB)),
                    ],
                  ),
                ),
              )
                  .animate(delay: 250.ms)
                  .fadeIn(duration: 450.ms),
            ],

            if (stats.totalGames == 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'No games played yet.\nStart a game to see your stats!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.4),
                        height: 1.6),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _SummaryRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7))),
          Text(value,
              style: TextStyle(
                  color:      color ??
                      Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize:   15)),
        ],
      );
}

class _Bar extends StatelessWidget {
  final String label;
  final int    count;
  final int    total;
  final Color  color;
  const _Bar(
      {required this.label,
      required this.count,
      required this.total,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : count / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
            Text('$count',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween:    Tween(begin: 0, end: pct),
            duration: const Duration(milliseconds: 800),
            curve:    Curves.easeOut,
            builder: (_, v, __) => LinearProgressIndicator(
              value:           v,
              minHeight:       10,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surface
                  .withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }
}
