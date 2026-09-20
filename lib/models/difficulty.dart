// models/difficulty.dart
// AI difficulty levels.

enum Difficulty { easy, medium, hard }

extension DifficultyLabel on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:   return 'Easy';
      case Difficulty.medium: return 'Medium';
      case Difficulty.hard:   return 'Hard';
    }
  }

  String get description {
    switch (this) {
      case Difficulty.easy:   return 'AI plays randomly';
      case Difficulty.medium: return 'AI alternates random and strategic';
      case Difficulty.hard:   return 'AI uses full strategy';
    }
  }
}
