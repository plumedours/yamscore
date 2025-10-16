import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../data/hive_boxes.dart';
import '../../data/models/player.dart';
import '../../data/models/game.dart';
import '../widgets/gradient_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _clearData(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Effacer toutes les données ?'),
        content: const Text(
          'Cette action supprimera tous les joueurs, parties et statistiques. Elle est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer tout'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      // IMPORTANT : utilisez la même signature de type que lors de l'ouverture !
      final Box<Player> playersBox = Hive.box<Player>(Boxes.players);
      final Box<Game> gamesBox = Hive.box<Game>(Boxes.games);

      await playersBox.clear();
      await gamesBox.clear();

      // Optionnel : si vous avez une box "settings"
      if (Hive.isBoxOpen(Boxes.settings)) {
        await Hive.box(Boxes.settings).clear();
      } else if (await Hive.boxExists(Boxes.settings)) {
        // si elle n'était pas ouverte mais existe sur disque, on peut la supprimer
        await Hive.deleteBoxFromDisk(Boxes.settings);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Toutes les données ont été supprimées.'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    return GradientScaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Thème sombre'),
            value: theme.mode == ThemeMode.dark,
            onChanged: (_) => context.read<ThemeController>().toggle(),
          ),
          const SizedBox(height: 30),
          const Divider(),
          const Text('Zone de danger', style: TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => _clearData(context),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Effacer toutes les données'),
          ),
        ],
      ),
    );
  }
}
