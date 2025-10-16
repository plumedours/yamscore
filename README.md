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

## 🔑 Signature & Builds

### Keystore (une seule fois)
```bash
# Windows (PowerShell)
keytool -genkeypair -v `
  -keystore "$env:USERPROFILE\yamscore-release.keystore" `
  -alias yamscore -keyalg RSA -keysize 2048 -validity 10000
```

Crée `android/key.properties` :
```properties
storePassword=TON_MDP_DE_KEYSTORE
keyPassword=TON_MDP_DE_CLE
keyAlias=yamscore
storeFile=C:\\Users\\<toi>\\yamscore-release.keystore
```

### APK léger (tests direct)
```bash
flutter build apk --release --split-per-abi --tree-shake-icons
# => build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### AAB (Play Store)
```bash
flutter build appbundle --release --tree-shake-icons
# => build/app/outputs/bundle/release/app-release.aab
```

## 🧪 Captures d’écran (exemples)
- Accueil : gestion joueurs, reprise de partie
- Feuille de score : navigation joueur, saisie, totaux
- Statistiques : bonus%, Yams%
- Paramètres & À propos

*(Ajoute tes images dans `/screenshots` et colle-les ici)*

## 🔒 Politique de confidentialité
Voir [`PRIVACY.md`](./PRIVACY.md).  
> YamScore ne collecte ni ne partage aucune donnée personnelle.  
> Toutes les informations restent sur **votre** appareil.

## 🛠️ Stack technique
- Flutter (Material 3), Hive, fl_chart
- Thème custom `GradientScaffold`, animations M3
- Stockage **offline-first**

## 🧾 Licence
© Plume d’Ours. Tous droits réservés.