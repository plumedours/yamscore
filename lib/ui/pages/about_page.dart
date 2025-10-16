import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../util/links.dart';
import '../widgets/gradient_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _openPlayStore(BuildContext context) async {
    final market = Uri.parse(AppLinks.marketUrl);
    final web = Uri.parse(AppLinks.playWebUrl);
    final gh = Uri.parse(AppLinks.githubRepo);

    // 1) Tente l’app Play Store
    if (await canLaunchUrl(market) &&
        await launchUrl(market, mode: LaunchMode.externalApplication)) {
      return;
    }
    // 2) Tente l’URL web Play
    if (await canLaunchUrl(web) &&
        await launchUrl(web, mode: LaunchMode.externalApplication)) {
      return;
    }
    // 3) Fallback GitHub
    if (await canLaunchUrl(gh)) {
      await launchUrl(gh, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le lien.")),
      );
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    // On partage d’abord l’URL Play (future-proof). Si elle n’est pas accessible sur l’appareil,
    // ce n’est pas bloquant pour le partage (c’est juste un texte).
    final text =
        'YamScore — Feuille de score Yams\n'
        '${AppLinks.playWebUrl}\n\n'
        'Si la page n’est pas encore en ligne, voici le dépôt : ${AppLinks.githubRepo}';
    await Share.share(text);
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Politique de confidentialité'),
        content: const SingleChildScrollView(
          child: Text(
            "YamScore ne collecte, ne stocke ni ne partage aucune donnée personnelle.\n"
            "Toutes les informations (joueurs, scores, statistiques) restent sur l’appareil.\n\n"
            "Vous pouvez effacer toutes les données depuis Paramètres → Zone de danger.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          FilledButton.tonal(
            onPressed: () async {
              final uri = Uri.parse(AppLinks.privacyUrl);
              Navigator.pop(context);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text('Ouvrir dans le navigateur'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.casino),
            title: Text('YamScore'),
            subtitle: Text('Feuille de score moderne pour Yams (Yahtzee)'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Partager l’app'),
            onTap: () => _shareApp(context),
            subtitle: const Text(
              'Envoie le lien du Play Store (ou GitHub en secours)',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shop_two_outlined),
            title: const Text('Ouvrir sur le Play Store'),
            onTap: () => _openPlayStore(context),
            subtitle: const Text(
              'Ouvre Play Store si disponible, sinon le site',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Politique de confidentialité'),
            onTap: () => _showPrivacyDialog(context),
            subtitle: Text(AppLinks.privacyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Dépôt GitHub'),
            subtitle: Text(AppLinks.githubRepo),
            onTap: () async {
              final uri = Uri.parse(AppLinks.githubRepo);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'YamScore fonctionne entièrement hors-ligne et ne requiert aucune connexion Internet.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}