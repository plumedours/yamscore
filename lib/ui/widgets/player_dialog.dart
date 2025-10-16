import 'package:flutter/material.dart';
import '../../util/color_utils.dart';
import '../../data/models/player.dart';
import '../../util/avatar.dart';

class PlayerDialog extends StatefulWidget {
  final Player? initial;

  const PlayerDialog({super.key, this.initial});

  @override
  State<PlayerDialog> createState() => _PlayerDialogState();
}

class _PlayerDialogState extends State<PlayerDialog> {
  late final TextEditingController nameController;
  late final TextEditingController badgeController;
  late Color selectedColor;
  String selectedAvatar = 'person';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initial?.name ?? '');
    badgeController = TextEditingController(text: widget.initial?.badge ?? '');
    selectedColor = widget.initial != null
        ? Color(widget.initial!.colorValue)
        : randomNiceColor();
    selectedAvatar = widget.initial?.avatarKey ?? 'person';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    widget.initial == null
                        ? 'Ajouter un joueur'
                        : 'Modifier le joueur',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: badgeController,
                decoration: const InputDecoration(
                  labelText: 'Badge/Émoji (optionnel) — ex: 🏆',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Couleur:'),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => selectedColor = randomNiceColor()),
                    child: CircleAvatar(backgroundColor: selectedColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '#${selectedColor.value.toRadixString(16).padLeft(8, '0')}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Avatar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final key in avatarKeys)
                    GestureDetector(
                      onTap: () => setState(() => selectedAvatar = key),
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedAvatar == key
                                ? selectedColor
                                : Theme.of(context).dividerColor,
                            width: selectedAvatar == key ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            iconFromKey(key),
                            size: 28,
                            color: selectedColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;
                      Navigator.pop(
                        context,
                        Player(
                          id: widget.initial?.id ?? 'tmp',
                          name: name,
                          colorValue: selectedColor.value,
                          avatarKey: selectedAvatar,
                          badge: badgeController.text.trim(),
                        ),
                      );
                    },
                    child: Text(
                      widget.initial == null ? 'Ajouter' : 'Enregistrer',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
