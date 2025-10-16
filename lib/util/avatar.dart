import 'package:flutter/material.dart';

/// Clé → IconData
IconData iconFromKey(String key) {
  switch (key) {
    case 'casino':
      return Icons.casino;
    case 'sports':
      return Icons.sports_esports;
    case 'rocket':
      return Icons.rocket_launch;
    case 'sailing':
      return Icons.sailing;
    case 'pets':
      return Icons.pets;
    case 'trophy':
      return Icons.emoji_events;
    case 'shield':
      return Icons.military_tech;
    case 'fire':
      return Icons.local_fire_department;
    case 'sparkles':
      return Icons.auto_awesome;
    case 'star':
      return Icons.star;
    case 'bolt':
      return Icons.bolt;
    case 'brain':
      return Icons.psychology;
    case 'puzzle':
      return Icons.extension;
    case 'anchor':
      return Icons.anchor;
    default:
      return Icons.person;
  }
}

/// Liste proposée (thème “tabletop / fun”)
const avatarKeys = <String>[
  'person',
  'casino',
  'sports',
  'rocket',
  'sailing',
  'pets',
  'trophy',
  'shield',
  'fire',
  'sparkles',
  'star',
  'bolt',
  'brain',
  'puzzle',
  'anchor',
];
