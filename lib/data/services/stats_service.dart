// import '../models/game.dart';
import '../models/player.dart';
import '../models/enums.dart';
import 'storage_service.dart';

class PlayerStats {
  final Player player;
  final int games;
  final double average;
  final int maxScore;
  final int minScore;
  final int total;
  final double bonusRate; // %
  final double yahtzeeRate; // %

  PlayerStats({
    required this.player,
    required this.games,
    required this.average,
    required this.maxScore,
    required this.minScore,
    required this.total,
    required this.bonusRate,
    required this.yahtzeeRate,
  });
}

class StatsService {
  final StorageService storage;

  StatsService(this.storage);

  List<PlayerStats> compute() {
    final players = storage.getAllPlayers();
    final games = storage.getAllGames().where((g) => g.isFinished).toList();

    final results = <PlayerStats>[];
    for (final p in players) {
      final scores = <int>[];
      int bonusCount = 0;
      int yaCount = 0;

      for (final g in games) {
        if (!g.playerIds.contains(p.id)) continue;
        final total = storage.totalFor(g.id, p.id);
        scores.add(total);

        if (storage.gotUpperBonus(g.id, p.id)) bonusCount++;

        final map = g.scores[p.id] ?? {};
        final yz = map[Category.yahtzee.index] ?? 0;
        if (yz > 0) yaCount++;
      }

      if (scores.isEmpty) {
        results.add(
          PlayerStats(
            player: p,
            games: 0,
            average: 0,
            maxScore: 0,
            minScore: 0,
            total: 0,
            bonusRate: 0,
            yahtzeeRate: 0,
          ),
        );
        continue;
      }

      final total = scores.reduce((a, b) => a + b);
      final avg = total / scores.length;
      scores.sort();
      final min = scores.first;
      final max = scores.last;

      final played = scores.length;
      results.add(
        PlayerStats(
          player: p,
          games: played,
          average: avg,
          maxScore: max,
          minScore: min,
          total: total,
          bonusRate: (bonusCount / played) * 100.0,
          yahtzeeRate: (yaCount / played) * 100.0,
        ),
      );
    }

    return results..sort((a, b) => b.average.compareTo(a.average));
  }
}
