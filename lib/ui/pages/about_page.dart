import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/gradient_scaffold.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted)
        setState(() => version = '${info.version}+${info.buildNumber}');
    });
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Politique de confidentialité'),
        content: const Text(
          'YamScore ne collecte ni n’envoie aucune donnée.\n'
          'Toutes vos informations (joueurs, parties, statistiques) restent stockées localement sur votre appareil.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              '🎲 YamScore',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Version $version'),
            const SizedBox(height: 16),
            const Text(
              'Feuille de score Yams (Yahtzee) moderne et 100 % locale.\n'
              'Pas de collecte, pas de publicité, pas d’Internet requis.',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _showPrivacyPolicy,
              icon: const Icon(Icons.privacy_tip),
              label: const Text('Politique de confidentialité'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Share.share(
                'Essaie YamScore 🎲 — Feuille de score Yams locale !',
              ),
              icon: const Icon(Icons.share),
              label: const Text('Partager YamScore'),
            ),
          ],
        ),
      ),
    );
  }
}
