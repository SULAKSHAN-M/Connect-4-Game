// themes/app_theme.dart
// Defines both Light and Dark Material 3 themes with Google Fonts.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color _primarySeed = Color(0xFF7C4DFF);
  static const Color playerRed     = Color(0xFFE53935);
  static const Color aiYellow      = Color(0xFFFDD835);

  static ThemeData get dark {
    final cs = ColorScheme.fromSeed(
      seedColor:  _primarySeed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3:            true,
      colorScheme:             cs,
      scaffoldBackgroundColor: const Color(0xFF0A0E1A),
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
        elevation:       0,
        centerTitle:     true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 18, fontWeight: FontWeight.bold,
          color: Colors.white, letterSpacing: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color:     const Color(0xFF111827),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2D3F60)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primarySeed,
          foregroundColor: Colors.white,
          elevation:       0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1,
          ),
        ),
      ),
      extensions: const [AppColors.dark],
    );
  }

  static ThemeData get light {
    final cs = ColorScheme.fromSeed(
      seedColor:  _primarySeed,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3:            true,
      colorScheme:             cs,
      scaffoldBackgroundColor: const Color(0xFFF0F4FF),
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF1A1A2E),
        elevation:       0,
        centerTitle:     true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 18, fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A2E), letterSpacing: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color:     Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFDDE3F0)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primarySeed,
          foregroundColor: Colors.white,
          elevation:       0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1,
          ),
        ),
      ),
      extensions: const [AppColors.light],
    );
  }
}

// ── Custom theme extension for board-specific colours ────────────────────────

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color boardBackground;
  final Color cellEmpty;
  final Color statusBar;
  final Color border;

  const AppColors({
    required this.boardBackground,
    required this.cellEmpty,
    required this.statusBar,
    required this.border,
  });

  static const dark = AppColors(
    boardBackground: Color(0xFF1A2035),
    cellEmpty:       Color(0xFF0D1117),
    statusBar:       Color(0xFF111827),
    border:          Color(0xFF2D3F60),
  );

  static const light = AppColors(
    boardBackground: Color(0xFF2C3E6A),
    cellEmpty:       Color(0xFFE8ECF4),
    statusBar:       Color(0xFFFFFFFF),
    border:          Color(0xFFDDE3F0),
  );

  @override
  AppColors copyWith({
    Color? boardBackground,
    Color? cellEmpty,
    Color? statusBar,
    Color? border,
  }) =>
      AppColors(
        boardBackground: boardBackground ?? this.boardBackground,
        cellEmpty:       cellEmpty       ?? this.cellEmpty,
        statusBar:       statusBar       ?? this.statusBar,
        border:          border          ?? this.border,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) {
      return this;
    }
    return AppColors(
      boardBackground: Color.lerp(boardBackground, other.boardBackground, t)!,
      cellEmpty:       Color.lerp(cellEmpty,       other.cellEmpty,       t)!,
      statusBar:       Color.lerp(statusBar,       other.statusBar,       t)!,
      border:          Color.lerp(border,          other.border,          t)!,
    );
  }
}
