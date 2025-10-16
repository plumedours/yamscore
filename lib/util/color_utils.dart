import 'dart:math';
import 'package:flutter/material.dart';

final _rand = Random();

Color randomNiceColor() {
  // Palette agréable
  final hues = [0, 30, 200, 260, 300, 340];
  final h = hues[_rand.nextInt(hues.length)].toDouble();
  final s = 0.65;
  final v = 0.85;
  return HSVColor.fromAHSV(1.0, h, s, v).toColor();
}

String initialsOf(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1)
    return parts.first.characters.take(2).toString().toUpperCase();
  return (parts.first.characters.first + parts.last.characters.first)
      .toUpperCase();
}
