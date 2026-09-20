// models/game_stats.dart
// Persistent win / loss / draw counters.

class GameStats {
  final int wins;
  final int losses;
  final int draws;

  const GameStats({this.wins = 0, this.losses = 0, this.draws = 0});

  int get totalGames => wins + losses + draws;

  double get winRate =>
      totalGames == 0 ? 0.0 : (wins / totalGames * 100);

  GameStats copyWith({int? wins, int? losses, int? draws}) => GameStats(
        wins:   wins   ?? this.wins,
        losses: losses ?? this.losses,
        draws:  draws  ?? this.draws,
      );

  @override
  String toString() =>
      'GameStats(wins: $wins, losses: $losses, draws: $draws)';
}
