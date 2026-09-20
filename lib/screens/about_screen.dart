// screens/about_screen.dart
// Displays app information, rules, and AI strategy descriptions.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ABOUT')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Logo / title ──────────────────────────────────────────────
          Center(
            child: ShaderMask(
              shaderCallback: (b) => const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFF1C40F)],
              ).createShader(b),
              child: Text(
                'CONNECT 4',
                style: GoogleFonts.orbitron(
                    fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Version 1.0.0  ·  CSP2108 Assignment',
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.45),
                  fontSize: 12),
            ),
          ),
          const SizedBox(height: 28),

          const _InfoCard(
            title: '🎮  HOW TO PLAY',
            body:
                'Tap a column to drop your disc (red). '
                'The disc falls to the lowest available row. '
                'Connect four of your discs in a horizontal, vertical, '
                'or diagonal line to win. '
                'If all 42 cells fill up with no winner, the game is a draw.',
          ),
          const SizedBox(height: 14),

          const _InfoCard(
            title: '🤖  AI DIFFICULTY',
            body:
                '• Easy — The AI picks a random legal column every turn.\n\n'
                '• Medium — The AI alternates between a random move and the '
                'full strategic move on each of its turns.\n\n'
                '• Hard — The AI uses a six-step rule-based strategy:\n'
                '  1. Win immediately if possible.\n'
                '  2. Block the player from winning.\n'
                '  3. Create three-in-a-row with an open end.\n'
                '  4. Prefer the centre column.\n'
                '  5. Prefer columns adjacent to the centre.\n'
                '  6. Choose any remaining legal column.',
          ),
          const SizedBox(height: 14),

          const _InfoCard(
            title: '⏱  TIMERS',
            body:
                'You have 40 seconds per turn and 4 minutes total. '
                'If either expires the app plays a random move on your behalf.',
          ),
          const SizedBox(height: 14),

          const _InfoCard(
            title: '↩  UNDO',
            body:
                'Tap the undo button to rewind a full turn — both your '
                'last move and the AI\'s last response are removed.',
          ),
          const SizedBox(height: 14),

          const _InfoCard(
            title: '📊  STATISTICS',
            body:
                'Wins, losses, and draws are saved to your device and '
                'persist across app restarts. Reset them any time in Settings.',
          ),
          const SizedBox(height: 24),

          Center(
            child: Text(
              'Built with Flutter & Dart · ECU CSP2108',
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.35),
                  fontSize: 11),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  const _InfoCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10),
              Text(body,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                      height: 1.6,
                      fontSize: 13)),
            ],
          ),
        ),
      );
}
