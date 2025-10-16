import 'package:flutter/material.dart';
import '../../data/models/enums.dart';
import '../../data/models/game.dart';
// import '../../data/services/storage_service.dart';
import 'score_cell.dart';
import '../../util/animations.dart';

class ScoreGrid extends StatelessWidget {
  final Game game;
  final int currentPlayerIndex;
  final void Function(Category) onTapCategory;
  final Category? lastEdited;

  const ScoreGrid({
    super.key,
    required this.game,
    required this.currentPlayerIndex,
    required this.onTapCategory,
    required this.lastEdited,
  });

  @override
  Widget build(BuildContext context) {
    // final storage = StorageService();
    final pid = game.playerIds[currentPlayerIndex];
    final map = game.scores[pid] ?? {};

    int sumUpper = 0;
    for (final c in upperCategories) {
      sumUpper += (map[c.index] ?? 0);
    }
    final bonus = sumUpper >= 63 ? 35 : 0;

    int sumLower = 0;
    for (final c in lowerCategories) {
      sumLower += (map[c.index] ?? 0);
    }
    final total = sumUpper + bonus + sumLower;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          'Partie supérieure',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ...upperCategories.map((c) {
                final v = map[c.index];
                return PulseOnChange(
                  watchKey: lastEdited == c ? Object() : '',
                  child: Card(
                    child: ScoreCell(
                      label: categoryLabel(c),
                      value: v?.toString() ?? '–',
                      onTap: () => onTapCategory(c),
                    ),
                  ),
                );
              }),
              Card(
                color: Colors.amber.withValues(alpha: 0.15),
                child: ListTile(
                  title: const Text('Sous-total (haut)'),
                  trailing: Text('$sumUpper'),
                ),
              ),
              Card(
                color: Colors.amber.withValues(alpha: 0.2),
                child: ListTile(
                  title: const Text('Bonus (>= 63)'),
                  trailing: Text('$bonus'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Partie inférieure',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.brown.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ...lowerCategories.map((c) {
                final v = map[c.index];
                return PulseOnChange(
                  watchKey: lastEdited == c ? Object() : '',
                  child: Card(
                    child: ScoreCell(
                      label: categoryLabel(c),
                      value: v?.toString() ?? '–',
                      onTap: () => onTapCategory(c),
                    ),
                  ),
                );
              }),
              Card(
                color: Colors.brown.withValues(alpha: 0.1),
                child: ListTile(
                  title: const Text('Sous-total (bas)'),
                  trailing: Text('$sumLower'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('Total'),
            trailing: Text(
              '$total',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
