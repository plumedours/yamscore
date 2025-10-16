import 'package:flutter/material.dart';
import '../../data/models/player.dart';
import '../../util/avatar.dart';
import '../pages/player_detail_page.dart';
import '../transitions/fade_route.dart';

class PlayerTile extends StatelessWidget {
  final Player player;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final Color color;

  const PlayerTile({
    super.key,
    required this.player,
    required this.selected,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: selected ? 1 : 0,
      child: ListTile(
        onTap: onTap,
        onLongPress: () {
          Navigator.push(
            context,
            FadeRoute(page: PlayerDetailPage(player: player)),
          );
        },
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(iconFromKey(player.avatarKey), color: Colors.white),
        ),
        title: Row(
          children: [
            Text(player.name),
            if (player.badge.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(player.badge, style: const TextStyle(fontSize: 18)),
              ),
          ],
        ),
        subtitle: Text(player.id),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onRename,
              tooltip: 'Modifier',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Supprimer',
            ),
            if (selected) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
