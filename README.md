# YamScore 🎲

**YamScore** est une feuille de score moderne pour le jeu de dés **Yams (Yahtzee)**.  
L’app est **100% locale** (pas d’Internet), rapide, et propose un thème **clair/sombre** “flat” soigné.

## ✨ Fonctionnalités

- Gestion **multi-joueurs** (nom, couleur, avatar, badge/emoji)
- **Feuille de score complète** (haut/bas), totaux et bonus automatiques, `Undo`
- **Reprise** d’une partie en cours, **historique** des parties, suppression
- **Statistiques avancées** : bonus%, Yams%, moyennes, min/max, cumul
- **Thème** clair/sombre avec **dégradés** subtils et header délimité
- **Paramètres** : thème, “zone de danger” (effacer toutes les données)
- **À propos** + Politique de confidentialité
- **Stockage local** via Hive (aucune donnée envoyée hors de l’appareil)

## 📦 Installation (dev)

```bash
flutter pub get
flutter run
```

> Nécessite Flutter stable, Android Studio/SDK, et un device ou émulateur.

```

## 🧪 Captures d’écran (exemples)
- Accueil : gestion joueurs, reprise de partie
- Feuille de score : navigation joueur, saisie, totaux
- Statistiques : bonus%, Yams%
- Paramètres & À propos

*(Ajoute tes images dans `/screenshots` et colle-les ici)*

## 🛠️ Stack technique
- Flutter (Material 3), Hive, fl_chart
- Thème custom `GradientScaffold`, animations M3
- Stockage **offline-first**

## 🧾 Licence
© Maxime Bory. Tous droits réservés.