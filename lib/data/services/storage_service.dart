import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive_boxes.dart';
import '../models/player.dart';
import '../models/game.dart';
import '../../util/id.dart';
import '../models/enums.dart';

class StorageService {
  final Box<Player> _players = Hive.box<Player>(Boxes.players);
  final Box<Game> _games = Hive.box<Game>(Boxes.games);

  // --- PLAYERS ---
  List<Player> getAllPlayers() => _players.values.toList();

  Player createPlayer(
    String name,
    Color color, {
    String avatarKey = 'person',
    String badge = '',
  }) {
    final p = Player(
      id: newId(),
      name: name,
      colorValue: color.value,
      avatarKey: avatarKey,
      badge: badge,
    );
    _players.put(p.id, p);
    return p;
  }

  void updatePlayer({
    required String id,
    String? name,
    Color? color,
    String? avatarKey,
    String? badge,
  }) {
    final p = _players.get(id);
    if (p != null) {
      if (name != null) p.name = name;
      if (color != null) p.colorValue = color.value;
      if (avatarKey != null) p.avatarKey = avatarKey;
      if (badge != null) p.badge = badge;
      p.save();
    }
  }

  void deletePlayer(String id) {
    _players.delete(id);
  }

  // --- GAMES ---
  Game newGame(List<String> playerIds) {
    final id = newId();
    final scores = <String, Map<int, int?>>{};
    for (final pid in playerIds) {
      scores[pid] = {};
    }
    final g = Game(
      id: id,
      playerIds: playerIds,
      scores: scores,
      createdAt: DateTime.now(),
      finishedAt: null,
      active: true,
    );
    _games.put(g.id, g);
    return g;
  }

  Game? getGame(String id) => _games.get(id);

  List<Game> getAllGames() => _games.values.toList();

  List<Game> getActiveGames() {
    final list = _games.values.where((g) => g.active && !g.isFinished).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void deleteGame(String id) => _games.delete(id);

  void setScore({
    required String gameId,
    required String playerId,
    required Category category,
    required int? score,
  }) {
    final g = _games.get(gameId);
    if (g == null) return;
    final catIndex = category.index;
    g.scores[playerId] ??= {};
    g.scores[playerId]![catIndex] = score;
    g.save();
  }

  void finishGame(String gameId) {
    final g = _games.get(gameId);
    if (g == null) return;
    g.finishedAt = DateTime.now();
    g.active = false;
    g.save();
  }

  // --- helpers ---
  int totalFor(String gameId, String playerId) {
    final g = _games.get(gameId);
    if (g == null) return 0;
    final map = g.scores[playerId] ?? {};
    int sumUpper = 0;
    for (final c in upperCategories) {
      sumUpper += (map[c.index] ?? 0);
    }
    final bonus = sumUpper >= 63 ? 35 : 0;

    int sumLower = 0;
    for (final c in lowerCategories) {
      sumLower += (map[c.index] ?? 0);
    }
    return sumUpper + bonus + sumLower;
  }

  bool gotUpperBonus(String gameId, String playerId) {
    final g = _games.get(gameId);
    if (g == null) return false;
    final map = g.scores[playerId] ?? {};
    int sumUpper = 0;
    for (final c in upperCategories) {
      sumUpper += (map[c.index] ?? 0);
    }
    return sumUpper >= 63;
  }
}
