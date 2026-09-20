// widgets/gradient_button.dart
// Reusable full-width gradient button used throughout the app.

import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final List<Color> colors;
  final double verticalPadding;
  final double fontSize;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.colors = const [Color(0xFF7C4DFF), Color(0xFF4F8EF7)],
    this.verticalPadding = 18,
    this.fontSize = 15,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.45 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          decoration: BoxDecoration(
            gradient:     LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: onTap != null
                ? [
                    BoxShadow(
                      color: colors.first.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color:       Colors.white,
              fontSize:    fontSize,
              fontWeight:  FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
