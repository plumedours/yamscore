import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/enums.dart';
import '../../data/models/game.dart';
import '../widgets/score_grid.dart';
import '../../util/score_logic.dart';
import '../../util/avatar.dart';
import '../../data/models/player.dart';
import '../widgets/gradient_scaffold.dart';

class GamePage extends StatefulWidget {
  final String gameId;
  const GamePage({super.key, required this.gameId});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final StorageService storage;
  late Game game;
  int currentPlayerIndex = 0;
  final history = <Move>[];
  Category? lastEdited;

  @override
  void initState() {
    super.initState();
    storage = StorageService();
    final g = storage.getGame(widget.gameId);
    if (g == null) throw Exception('Partie introuvable');
    game = g;
  }

  void _prev() {
    setState(() {
      currentPlayerIndex = (currentPlayerIndex - 1) % game.playerIds.length;
      if (currentPlayerIndex < 0) currentPlayerIndex += game.playerIds.length;
    });
  }

  void _next() {
    setState(() {
      currentPlayerIndex = (currentPlayerIndex + 1) % game.playerIds.length;
    });
  }

  Future<void> _enterScore(Category c) async {
    final pid = game.playerIds[currentPlayerIndex];
    final map = game.scores[pid] ?? {};
    final prev = map[c.index];

    final suggested = suggestScore(c);
    final controller = TextEditingController(
      text: prev?.toString() ?? suggested?.toString() ?? '',
    );

    final value = await showDialog<int?>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Saisir score — ${categoryLabel(c)}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Entrez un entier (ou laissez vide pour -)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Vider (–)'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 0),
            child: const Text('0'),
          ),
          FilledButton(
            onPressed: () {
              final t = controller.text.trim();
              if (t.isEmpty) {
                Navigator.pop(context, null);
              } else {
                final n = int.tryParse(t);
                Navigator.pop(context, n);
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );

    if (value == null && prev == null) return;

    setState(() {
      history.add(Move(playerId: pid, category: c, previous: prev));
      storage.setScore(
        gameId: game.id,
        playerId: pid,
        category: c,
        score: value,
      );
      game = storage.getGame(game.id)!;
      lastEdited = c;
    });
  }

  void _undo() {
    if (history.isEmpty) return;
    final last = history.removeLast();
    storage.setScore(
      gameId: game.id,
      playerId: last.playerId,
      category: last.category,
      score: last.previous,
    );
    setState(() {
      game = storage.getGame(game.id)!;
      lastEdited = last.category;
    });
  }

  void _finish() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Fin de partie'),
        content: const Text('Enregistrer la partie dans l’historique ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      storage.finishGame(game.id);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickPlayer() async {
    final chosen = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView.builder(
            itemCount: game.playerIds.length,
            itemBuilder: (ctx, i) {
              final pid = game.playerIds[i];
              final p = storage.getAllPlayers().firstWhere(
                (pp) => pp.id == pid,
                orElse: () =>
                    Player(id: pid, name: 'Joueur', colorValue: 0xFF9CA3AF),
              );
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(p.colorValue),
                  child: Icon(iconFromKey(p.avatarKey), color: Colors.white),
                ),
                title: Text(p.name),
                onTap: () => Navigator.pop(ctx, i),
              );
            },
          ),
        );
      },
    );
    if (chosen != null) {
      setState(() => currentPlayerIndex = chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pid = game.playerIds[currentPlayerIndex];
    final p = storage.getAllPlayers().firstWhere(
      (pp) => pp.id == pid,
      orElse: () => Player(id: pid, name: 'Joueur', colorValue: 0xFF9CA3AF),
    );
    final total = storage.totalFor(game.id, pid);

    return GradientScaffold(
      appBar: AppBar(
        // LIGNE 1 : chevrons + nom (ellipsé) + pick player
        title: Row(
          children: [
            IconButton(
              onPressed: _prev,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Joueur précédent',
            ),
            Expanded(
              child: GestureDetector(
                onTap: _pickPlayer,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(p.colorValue),
                      child: Icon(
                        iconFromKey(p.avatarKey),
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Nom ellipsé pour éviter de pousser les boutons
                    Expanded(
                      child: Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (p.badge.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(p.badge, style: const TextStyle(fontSize: 16)),
                    ],
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: _next,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Joueur suivant',
            ),
          ],
        ),

        // LIGNE 2 : à gauche Total, à droite Undo + Fin
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                // Total à gauche, petit
                Expanded(
                  child: Text(
                    'Total: $total',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Boutons à droite
                IconButton(
                  onPressed: _undo,
                  icon: const Icon(Icons.undo),
                  tooltip: 'Annuler le dernier tour',
                ),
                const SizedBox(width: 4),
                FilledButton.icon(
                  onPressed: _finish,
                  icon: const Icon(Icons.flag),
                  label: const Text('Fin'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // On ne met rien dans actions pour éviter tout chevauchement
        actions: const [],
      ),

      body: ScoreGrid(
        game: game,
        currentPlayerIndex: currentPlayerIndex,
        onTapCategory: _enterScore,
        lastEdited: lastEdited,
      ),
    );
  }
}

class Move {
  final String playerId;
  final Category category;
  final int? previous;
  Move({
    required this.playerId,
    required this.category,
    required this.previous,
  });
}