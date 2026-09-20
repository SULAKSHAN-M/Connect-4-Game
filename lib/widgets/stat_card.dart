// widgets/stat_card.dart
// Compact card displaying a single statistic (wins / losses / draws).

import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final int    value;
  final Color  color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color:        Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color:      color,
              fontSize:   30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
              fontSize:   11,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
