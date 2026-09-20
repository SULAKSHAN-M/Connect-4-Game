// screens/splash_screen.dart
// Animated splash screen shown on app launch.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Board icon
            _BoardIcon()
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 32),

            // Title
            ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFF1C40F)],
              ).createShader(b),
              child: Text(
                'CONNECT 4',
                style: GoogleFonts.orbitron(
                  fontSize:   48,
                  fontWeight: FontWeight.w900,
                  color:      Colors.white,
                  letterSpacing: 4,
                ),
              ),
            )
                .animate(delay: 300.ms)
                .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOut)
                .fadeIn(duration: 500.ms),

            const SizedBox(height: 8),

            Text(
              'HUMAN VS AI',
              style: TextStyle(
                color:       Colors.white.withValues(alpha: 0.45),
                fontSize:    13,
                letterSpacing: 6,
              ),
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 600.ms),

            const SizedBox(height: 60),

            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
              strokeWidth: 2,
            )
                .animate(delay: 900.ms)
                .fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}

// ── Mini board icon ───────────────────────────────────────────────────────────

class _BoardIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const disc = [
      [false, false, false, false, false],
      [false, true,  false, false, false],
      [false, true,  false, false, false],
      [false, true,  false, true,  false],
      [false, true,  true,  true,  false],
    ];
    const discColors = [
      Color(0xFFE53935),
      Color(0xFFFDD835),
    ];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:        const Color(0xFF1A2035),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D3F60), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(disc.length, (r) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(disc[r].length, (c) {
            final filled = disc[r][c];
            return Container(
              width:  14, height: 14,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled
                    ? discColors[(r + c) % 2]
                    : const Color(0xFF0D1117),
              ),
            );
          }),
        )),
      ),
    );
  }
}
