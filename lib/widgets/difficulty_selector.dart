// widgets/difficulty_selector.dart
// Segmented row for selecting Easy / Medium / Hard.

import 'package:flutter/material.dart';
import '../models/difficulty.dart';

class DifficultySelector extends StatelessWidget {
  final Difficulty selected;
  final ValueChanged<Difficulty> onChanged;

  const DifficultySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Difficulty.values.map((d) {
        final isActive = d == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(left: d.index == 0 ? 0 : 6),
              padding: const EdgeInsets.symmetric(vertical: 11),
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
                d.label,
                style: TextStyle(
                  color:      isActive
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                  fontSize:   13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
