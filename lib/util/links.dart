class AppLinks {
  // Ton package id Play Store
  static const packageId = 'com.plumedours.yamscore';

  // Cible Play Store (app) + web
  static const marketUrl = 'market://details?id=$packageId';
  static const playWebUrl =
      'https://play.google.com/store/apps/details?id=$packageId';

  // Fallback (avant publication) — ton dépôt public
  static const githubRepo = 'https://github.com/plumedours/yamscore';

  // Politique (tu peux remplacer par ton GitHub Pages si tu actives Pages)
  static const privacyUrl =
      'https://github.com/plumedours/yamscore/blob/main/PRIVACY.md';
}
