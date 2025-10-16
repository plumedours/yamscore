import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Player extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorValue; // ARGB

  @HiveField(3, defaultValue: 'person')
  String avatarKey;

  @HiveField(4, defaultValue: '')
  String badge; // émoji ou petit texte

  Player({
    required this.id,
    required this.name,
    required this.colorValue,
    this.avatarKey = 'person',
    this.badge = '',
  });
}

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 1;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      id: fields[0] as String,
      name: fields[1] as String,
      colorValue: fields[2] as int,
      avatarKey: (fields.containsKey(3) ? fields[3] as String : 'person'),
      badge: (fields.containsKey(4) ? fields[4] as String : ''),
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.colorValue)
      ..writeByte(3)
      ..write(obj.avatarKey)
      ..writeByte(4)
      ..write(obj.badge);
  }
}
