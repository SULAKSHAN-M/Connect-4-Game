// screens/home_screen.dart
// Landing screen: scores, difficulty picker, first-player picker, navigation.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_routes.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/gradient_button.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CONNECT 4'),
        actions: [
          IconButton(
            icon:    const Icon(Icons.bar_chart_rounded),
            tooltip: 'Statistics',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.statistics),
          ),
          IconButton(
            icon:    const Icon(Icons.settings_rounded),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          IconButton(
            icon:    const Icon(Icons.info_outline_rounded),
            tooltip: 'About',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.about),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Title ────────────────────────────────────────────────
              _buildTitle(context)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.2, duration: 500.ms),
              const SizedBox(height: 28),

              // ── Score row ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatCard(label: 'WINS',   value: gp.stats.wins,   color: const Color(0xFF2ECC71)),
                  StatCard(label: 'DRAWS',  value: gp.stats.draws,  color: const Color(0xFF8899BB)),
                  StatCard(label: 'LOSSES', value: gp.stats.losses, color: const Color(0xFFE74C3C)),
                ],
              )
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, duration: 500.ms),
              const SizedBox(height: 28),

              // ── Difficulty ────────────────────────────────────────────
              _SettingsCard(
                title: 'DIFFICULTY',
                child: DifficultySelector(
                  selected:  gp.difficulty,
                  onChanged: gp.setDifficulty,
                ),
              )
                  .animate(delay: 200.ms)
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 14),

              // ── Who goes first ────────────────────────────────────────
              _SettingsCard(
                title: 'WHO GOES FIRST',
                child: _FirstPlayerRow(
                  selected:  gp.firstPref,
                  onChanged: gp.setFirstPref,
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 36),

              // ── Start button ──────────────────────────────────────────
              GradientButton(
                label: 'START GAME',
                onTap: () {
                  gp.startGame();
                  Navigator.pushNamed(context, AppRoutes.game);
                },
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, duration: 500.ms),
              const SizedBox(height: 16),

              // ── Legend ────────────────────────────────────────────────
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(color: Color(0xFFE53935), label: 'You  (Red)'),
                  SizedBox(width: 20),
                  _LegendDot(color: Color(0xFFFDD835), label: 'AI  (Yellow)'),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFF1C40F)],
          ).createShader(b),
          child: Text(
            'CONNECT 4',
            textAlign:  TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize:   38,
              fontWeight: FontWeight.w900,
              color:      Colors.white,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'HUMAN VS AI',
          textAlign: TextAlign.center,
          style: TextStyle(
            color:       isDark
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.4),
            fontSize:    12,
            letterSpacing: 5,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                      fontSize:    11,
                      letterSpacing: 3,
                      fontWeight:  FontWeight.w600)),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );
}

class _FirstPlayerRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _FirstPlayerRow({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('random', 'Random'),
      ('human',  'Me First'),
      ('ai',     'AI First'),
    ];
    return Row(
      children: items.map((e) {
        final isActive = e.$1 == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(e.$1),
            child: AnimatedContainer(
              duration:    const Duration(milliseconds: 200),
              margin: EdgeInsets.only(left: items.indexOf(e) == 0 ? 0 : 6),
              padding:     const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color:        isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                e.$2,
                style: TextStyle(
                  color:      isActive
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                  fontSize:   12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width:  12, height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                color:    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                fontSize: 12)),
      ]);
}
