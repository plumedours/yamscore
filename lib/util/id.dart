import 'dart:math';

final _rng = Random.secure();

String newId({int bytes = 8}) {
  final buf = List<int>.generate(bytes, (_) => _rng.nextInt(256));
  return buf.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
