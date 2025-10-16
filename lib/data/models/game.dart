import 'package:hive/hive.dart';
import 'enums.dart';

/// Historique d’une saisie pour UNDO (non persisté)
class Move {
  final String playerId;
  final Category category;
  final int? previous; // score précédent (peut être null si vide)

  Move({
    required this.playerId,
    required this.category,
    required this.previous,
  });
}

@HiveType(typeId: 2)
class Game extends HiveObject {
  @HiveField(0)
  String id;

  /// IDs des joueurs participant à cette partie
  @HiveField(1)
  List<String> playerIds;

  /// scores[playerId][categoryIndex] = score ou null
  @HiveField(2)
  Map<String, Map<int, int?>> scores;

  /// Flag d’activité (persisté)
  @HiveField(3, defaultValue: true)
  bool active;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? finishedAt;

  Game({
    required this.id,
    required this.playerIds,
    required this.scores,
    required this.createdAt,
    this.finishedAt,
    this.active = true,
  });

  bool get isFinished => finishedAt != null;
}

/// ==== MANUAL ADAPTER ====
class GameAdapter extends TypeAdapter<Game> {
  @override
  final int typeId = 2;

  @override
  Game read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Game(
      id: fields[0] as String,
      playerIds: (fields[1] as List).cast<String>(),
      scores: (fields[2] as Map).map(
        (k, v) => MapEntry(
          k as String,
          (v as Map).map((kk, vv) => MapEntry(kk as int, vv as int?)),
        ),
      ),
      active: fields[3] as bool? ?? true,
      createdAt: fields[4] as DateTime,
      finishedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playerIds)
      ..writeByte(2)
      ..write(obj.scores)
      ..writeByte(3)
      ..write(obj.active)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.finishedAt);
  }
}
