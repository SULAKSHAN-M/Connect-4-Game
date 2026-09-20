// lib/main.dart
// Application entry point. Sets up the Provider tree and named routes.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';
import 'themes/app_theme.dart';
import 'themes/theme_provider.dart';
import 'utils/app_routes.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/about_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        // Theme state — initialised asynchronously from shared_preferences
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..init(),
        ),
        // Central game state (also loads stats + difficulty on creation)
        ChangeNotifierProvider(
          create: (_) => GameProvider()..init(),
        ),
      ],
      child: const Connect4App(),
    ),
  );
}

class Connect4App extends StatelessWidget {
  const Connect4App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title:                  'Connect 4',
      debugShowCheckedModeBanner: false,
      theme:                  AppTheme.light,
      darkTheme:              AppTheme.dark,
      themeMode:              themeProvider.isDark
          ? ThemeMode.dark
          : ThemeMode.light,

      // Named routes
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash:     (_) => const SplashScreen(),
        AppRoutes.home:       (_) => const HomeScreen(),
        AppRoutes.game:       (_) => const GameScreen(),
        AppRoutes.settings:   (_) => const SettingsScreen(),
        AppRoutes.statistics: (_) => const StatisticsScreen(),
        AppRoutes.about:      (_) => const AboutScreen(),
      },
    );
  }
}
