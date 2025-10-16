import 'package:flutter/material.dart';

/// Palette douce, moderne, peu saturée.
/// On garde un contraste suffisant et un rendu "flat".
class AppTheme {
  // Couleurs racine (light)
  static const _lightBgTop = Color(0xFFF8FAFC); // gris bleu très clair
  static const _lightBgBottom = Color(0xFFEFF4F9); // à peine plus soutenu
  static const _lightPrimary = Color(0xFF334155); // slate-700
  static const _lightSecondary = Color(0xFF64748B); // slate-500
  static const _lightOutline = Color(0xFFE5E7EB);

  // Couleurs racine (dark)
  static const _darkBgTop = Color(0xFF0B0D12); // presque noir bleuté
  static const _darkBgBottom = Color(0xFF10131A); // très sombre
  static const _darkPrimary = Color(0xFFE5E7EB); // gris clair
  static const _darkSecondary = Color(0xFF9CA3AF);
  static const _darkOutline = Color(0xFF232731);

  static ThemeData get light {
    final scheme = const ColorScheme.light(
      primary: _lightPrimary,
      onPrimary: Colors.white,
      secondary: _lightSecondary,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1F2937), // slate-800 (texte principal)
      background: Colors.white,
      onBackground: Color(0xFF1F2937),
      outline: _lightOutline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          Colors.transparent, // on gère le fond avec GradientScaffold
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent, // gradient via flexibleSpace
        foregroundColor: _lightPrimary,
      ),
      cardColor: Colors.white,
      dividerColor: _lightOutline,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF1F2937)),
        bodySmall: TextStyle(color: Color(0xFF6B7280)),
        titleMedium: TextStyle(
          color: Color(0xFF111827),
          fontWeight: FontWeight.w600,
        ),
      ),
      listTileTheme: const ListTileThemeData(iconColor: Color(0xFF4B5563)),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightPrimary.withOpacity(0.7)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = const ColorScheme.dark(
      primary: _darkPrimary,
      onPrimary: Color(0xFF0B0D12),
      secondary: _darkSecondary,
      onSecondary: Color(0xFF0B0D12),
      surface: Color(0xFF141822),
      onSurface: _darkPrimary,
      background: Color(0xFF0B0D12),
      onBackground: _darkPrimary,
      outline: _darkOutline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          Colors.transparent, // fond géré par GradientScaffold
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: _darkPrimary,
      ),
      cardColor: const Color(0xFF141822),
      dividerColor: _darkOutline,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFE5E7EB)),
        bodySmall: TextStyle(color: Color(0xFF9CA3AF)),
        titleMedium: TextStyle(
          color: Color(0xFFE5E7EB),
          fontWeight: FontWeight.w600,
        ),
      ),
      listTileTheme: const ListTileThemeData(iconColor: Color(0xFFCBD5E1)),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
    );
  }

  /// Gradient d’arrière-plan (scaffold)
  static LinearGradient scaffoldGradient(Brightness b) => (b == Brightness.dark)
      ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_darkBgTop, _darkBgBottom],
        )
      : const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_lightBgTop, _lightBgBottom],
        );

  /// Gradient d’AppBar (très subtil) + ligne de séparation en bas
  static LinearGradient appBarGradient(Brightness b) => (b == Brightness.dark)
      ? LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0C0F15),
            const Color(0xFF10131A).withOpacity(0.9),
          ],
        )
      : LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFFDFEFF), const Color(0xFFF3F7FB)],
        );

  /// Couleur de la ligne de séparation sous l’AppBar
  static Color appBarBottomBorder(Brightness b) =>
      (b == Brightness.dark) ? _darkOutline : _lightOutline;
}
