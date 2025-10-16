import 'package:flutter/material.dart';

class ScoreCell extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const ScoreCell({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      ),
    );
    if (onTap == null) return tile;
    return InkWell(onTap: onTap, child: tile);
  }
}
