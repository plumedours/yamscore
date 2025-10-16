import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/hive_boxes.dart';
import 'data/models/player.dart';
import 'data/models/game.dart';
import 'ui/app_theme.dart';
import 'ui/pages/home_page.dart';
// import 'data/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Enregistrer les adapters (écrits à la main)
  if (!Hive.isAdapterRegistered(PlayerAdapter().typeId)) {
    Hive.registerAdapter(PlayerAdapter());
  }
  if (!Hive.isAdapterRegistered(GameAdapter().typeId)) {
    Hive.registerAdapter(GameAdapter());
  }

  await Hive.openBox(Boxes.settings);
  await Hive.openBox<Player>(Boxes.players);
  await Hive.openBox<Game>(Boxes.games);

  runApp(const YamScoreApp());
}

class YamScoreApp extends StatelessWidget {
  const YamScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'YamScore',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: theme.mode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

/// Contrôleur de thème (persisté dans Hive)
class ThemeController extends ChangeNotifier {
  static const _key = 'themeMode';
  ThemeMode _mode;

  ThemeController() : _mode = _loadInitial();

  static ThemeMode _loadInitial() {
    final box = Hive.box(Boxes.settings);
    final v = box.get(_key, defaultValue: 'system');
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeMode get mode => _mode;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _persist();
    notifyListeners();
  }

  void set(ThemeMode m) {
    _mode = m;
    _persist();
    notifyListeners();
  }

  void _persist() {
    final box = Hive.box(Boxes.settings);
    final value = switch (_mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    box.put(_key, value);
  }
}
