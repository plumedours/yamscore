import 'package:flutter/material.dart';
import '../../data/models/player.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/stats_service.dart';
// import '../../data/models/enums.dart';
import '../widgets/gradient_scaffold.dart';

class PlayerDetailPage extends StatelessWidget {
  final Player player;
  const PlayerDetailPage({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final games = storage
        .getAllGames()
        .where((g) => g.playerIds.contains(player.id))
        .toList();
    final stats = StatsService(storage).compute().firstWhere(
      (s) => s.player.id == player.id,
      orElse: () => PlayerStats(
        player: player,
        games: 0,
        average: 0,
        maxScore: 0,
        minScore: 0,
        total: 0,
        bonusRate: 0,
        yahtzeeRate: 0,
      ),
    );

    return GradientScaffold(
      appBar: AppBar(title: Text(player.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Color(player.colorValue)),
              const SizedBox(width: 12),
              Text(player.name, style: Theme.of(context).textTheme.titleLarge),
              if (player.badge.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    player.badge,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _statCard(context, 'Parties', '${stats.games}'),
              _statCard(context, 'Moyenne', stats.average.toStringAsFixed(1)),
              _statCard(context, 'Max', '${stats.maxScore}'),
              _statCard(context, 'Min', '${stats.minScore}'),
              _statCard(
                context,
                'Bonus %',
                '${stats.bonusRate.toStringAsFixed(0)}%',
              ),
              _statCard(
                context,
                'Yams %',
                '${stats.yahtzeeRate.toStringAsFixed(0)}%',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Historique des parties',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (games.isEmpty) const Text('Aucune partie.'),
          ...games.map((g) {
            final total = storage.totalFor(g.id, player.id);
            final finished = g.isFinished ? 'Terminée' : 'En cours';
            return Card(
              child: ListTile(
                title: Text(
                  'Partie ${g.id.substring(0, 6).toUpperCase()} — $finished',
                ),
                subtitle: Text('Créée le ${g.createdAt}'),
                trailing: Text('$total'),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String label, String value) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
