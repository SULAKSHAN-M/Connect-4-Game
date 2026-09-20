// screens/settings_screen.dart
// Allows the player to change difficulty, toggle theme, and reset statistics.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../themes/theme_provider.dart';
import '../widgets/difficulty_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gp   = context.watch<GameProvider>();
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Difficulty ────────────────────────────────────────────────
          _Section(
            title: 'AI DIFFICULTY',
            child: DifficultySelector(
              selected:  gp.difficulty,
              onChanged: gp.setDifficulty,
            ),
          ),
          const SizedBox(height: 20),

          // ── First player ──────────────────────────────────────────────
          _Section(
            title: 'WHO GOES FIRST',
            child: _FirstPlayerSetting(
              selected:  gp.firstPref,
              onChanged: gp.setFirstPref,
            ),
          ),
          const SizedBox(height: 20),

          // ── Theme toggle ──────────────────────────────────────────────
          _Section(
            title: 'APPEARANCE',
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode'),
              subtitle: Text(
                theme.isDark ? 'Dark theme active' : 'Light theme active',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                    fontSize: 12),
              ),
              value:    theme.isDark,
              onChanged: (_) => theme.toggle(),
            ),
          ),
          const SizedBox(height: 20),

          // ── Reset stats ───────────────────────────────────────────────
          _Section(
            title: 'DATA',
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reset Statistics',
                  style: TextStyle(color: Color(0xFFE74C3C))),
              subtitle: Text(
                'Clears all wins, losses and draws.',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                    fontSize: 12),
              ),
              trailing: const Icon(Icons.delete_sweep_rounded,
                  color: Color(0xFFE74C3C)),
              onTap: () => _confirmReset(context, gp),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, GameProvider gp) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset Statistics'),
        content: const Text(
            'This will permanently delete all wins, losses, and draws.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C)),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await gp.resetStats();
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45),
                  fontSize:    11,
                  letterSpacing: 3,
                  fontWeight:  FontWeight.w600)),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child:   child,
            ),
          ),
        ],
      );
}

class _FirstPlayerSetting extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _FirstPlayerSetting({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [('random', 'Random'), ('human', 'Me First'), ('ai', 'AI First')];
    return Row(
      children: items.map((e) {
        final isActive = e.$1 == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(e.$1),
            child: AnimatedContainer(
              duration:    const Duration(milliseconds: 200),
              margin: EdgeInsets.only(left: items.indexOf(e) == 0 ? 0 : 6),
              padding:     const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color:        isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              alignment: Alignment.center,
              child: Text(e.$2,
                  style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                      fontSize:   12)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
