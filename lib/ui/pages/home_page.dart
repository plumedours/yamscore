import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // << nécessaire pour Box.listenable()
import '../../data/hive_boxes.dart';
import '../../data/models/player.dart';
import '../../data/models/game.dart';
import '../../data/services/storage_service.dart';
import '../widgets/player_dialog.dart';
import '../widgets/player_tile.dart';
import 'game_page.dart';
import 'stats_page.dart';
import 'settings_page.dart';
import 'about_page.dart';
// import '../../util/color_utils.dart';
import '../../../main.dart';
import '../transitions/fade_route.dart';
import '../widgets/gradient_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StorageService storage;
  final selected = <String>{};

  @override
  void initState() {
    super.initState();
    storage = StorageService();
  }

  Future<void> _addPlayer() async {
    final result = await showDialog<Player?>(
      context: context,
      builder: (_) => const PlayerDialog(),
    );
    if (result != null) {
      setState(() {
        storage.createPlayer(
          result.name,
          Color(result.colorValue),
          avatarKey: result.avatarKey,
          badge: result.badge,
        );
      });
    }
  }

  Future<void> _editPlayer(Player p) async {
    final result = await showDialog<Player?>(
      context: context,
      builder: (_) => PlayerDialog(initial: p),
    );
    if (result != null) {
      setState(() {
        storage.updatePlayer(
          id: p.id,
          name: result.name,
          color: Color(result.colorValue),
          avatarKey: result.avatarKey,
          badge: result.badge,
        );
      });
    }
  }

  void _deletePlayer(Player p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer'),
        content: Text('Supprimer ${p.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        storage.deletePlayer(p.id);
        selected.remove(p.id);
      });
    }
  }

  void _startGame() {
    if (selected.isEmpty) {
      _addPlayer();
      return;
    }
    final g = storage.newGame(selected.toList());
    Navigator.of(context)
        .push(FadeRoute(page: GamePage(gameId: g.id)))
        .then((_) => setState(() {})); // refresh au retour
  }

  void _openGame(String gameId) {
    Navigator.of(context)
        .push(FadeRoute(page: GamePage(gameId: gameId)))
        .then((_) => setState(() {})); // refresh au retour
  }

  void _chooseActiveGame(List<Game> actives) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView.separated(
          itemCount: actives.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (_, i) {
            final g = actives[i];
            final created =
                '${g.createdAt.year}-${g.createdAt.month.toString().padLeft(2, '0')}-${g.createdAt.day.toString().padLeft(2, '0')} '
                '${g.createdAt.hour.toString().padLeft(2, '0')}:${g.createdAt.minute.toString().padLeft(2, '0')}';
            return ListTile(
              leading: const Icon(Icons.play_circle),
              title: Text('Partie ${g.id.substring(0, 6).toUpperCase()}'),
              subtitle: Text(
                'Créée le $created • ${g.playerIds.length} joueur(s)',
              ),
              onTap: () {
                Navigator.pop(ctx);
                _openGame(g.id);
              },
              trailing: IconButton(
                tooltip: 'Supprimer',
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Supprimer la partie ?'),
                      content: const Text('Cette action est irréversible.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Supprimer'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    storage.deleteGame(g.id);
                    if (context.mounted) Navigator.pop(ctx); // ferme la sheet
                    setState(() {});
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    // On écoute la box Hive des parties : l’UI se met à jour automatiquement
    final gamesBox = Hive.box<Game>(Boxes.games);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('YamScore'),
        actions: [
          IconButton(
            tooltip: 'Statistiques',
            onPressed: () {
              Navigator.push(context, FadeRoute(page: const StatsPage()));
            },
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            tooltip: 'Paramètres',
            onPressed: () {
              Navigator.push(context, FadeRoute(page: const SettingsPage()));
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            tooltip: 'À propos',
            onPressed: () {
              Navigator.push(context, FadeRoute(page: const AboutPage()));
            },
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            tooltip: 'Basculer Thème',
            onPressed: theme.toggle,
            icon: const Icon(Icons.brightness_6),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startGame,
        label: Text(selected.isEmpty ? 'Ajouter un joueur' : 'Nouvelle partie'),
        icon: Icon(selected.isEmpty ? Icons.person_add : Icons.casino),
      ),

      body: ValueListenableBuilder(
        valueListenable: gamesBox.listenable(),
        builder: (context, _, __) {
          // Recalculer à chaque changement
          final storage = StorageService();
          final players = storage.getAllPlayers();
          final activeGames = storage.getActiveGames();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // Bandeau reprise
              if (activeGames.isNotEmpty) ...[
                Card(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                  child: ListTile(
                    leading: const Icon(Icons.play_circle),
                    title: Text(
                      'Reprendre ${activeGames.length} partie(s) en cours',
                    ),
                    onTap: () {
                      // S’il n’y en a qu’une : ouvre directement
                      if (activeGames.length == 1) {
                        _openGame(activeGames.first.id);
                      } else {
                        _chooseActiveGame(activeGames);
                      }
                    },
                    trailing: activeGames.length > 1
                        ? TextButton.icon(
                            onPressed: () => _chooseActiveGame(activeGames),
                            icon: const Icon(Icons.list),
                            label: const Text('Choisir'),
                          )
                        : PopupMenuButton(
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Supprimer'),
                              ),
                            ],
                            onSelected: (v) {
                              if (v == 'delete') {
                                storage.deleteGame(activeGames.first.id);
                                setState(() {});
                              }
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // En-tête vivant
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.casino, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Prépare tes dés !',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),

              // Actions rapides
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: _addPlayer,
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un joueur'),
                  ),
                  const SizedBox(width: 12),
                  Text('Sélectionnés: ${selected.length}'),
                ],
              ),
              const SizedBox(height: 12),

              // Liste des joueurs
              if (players.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('Aucun joueur enregistré.'),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _addPlayer,
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un joueur'),
                      ),
                    ],
                  ),
                )
              else
                ...players.map(
                  (p) => PlayerTile(
                    player: p,
                    selected: selected.contains(p.id),
                    onTap: () {
                      setState(() {
                        if (selected.contains(p.id)) {
                          selected.remove(p.id);
                        } else {
                          selected.add(p.id);
                        }
                      });
                    },
                    onRename: () => _editPlayer(p),
                    onDelete: () => _deletePlayer(p),
                    color: Color(p.colorValue),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
