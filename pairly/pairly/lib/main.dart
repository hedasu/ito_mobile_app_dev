import 'package:flutter/material.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/state/app_settings_controller.dart';
import 'package:pairly/core/state/notifier_scope.dart';
import 'package:pairly/core/theme/app_theme.dart';
import 'package:pairly/features/home/presentation/home_screen.dart';
import 'package:pairly/features/statistics/presentation/statistics_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = AppSettingsController();
  final statisticsController = StatisticsController();

  await Future.wait([
    settingsController.loadSettings(),
    statisticsController.loadStatistics(),
  ]);

  runApp(
    PairlyApp(
      settingsController: settingsController,
      statisticsController: statisticsController,
    ),
  );
}

/// Pairly uygulamasının kök widget'ı.
class PairlyApp extends StatefulWidget {
  const PairlyApp({
    super.key,
    this.settingsController,
    this.statisticsController,
  });

  final AppSettingsController? settingsController;
  final StatisticsController? statisticsController;

  @override
  State<PairlyApp> createState() => _PairlyAppState();
}

class _PairlyAppState extends State<PairlyApp> {
  late final AppSettingsController _settingsController;
  late final StatisticsController _statisticsController;
  late final bool _ownsSettings;
  late final bool _ownsStatistics;

  @override
  void initState() {
    super.initState();
    _ownsSettings = widget.settingsController == null;
    _ownsStatistics = widget.statisticsController == null;
    _settingsController = widget.settingsController ?? AppSettingsController();
    _statisticsController =
        widget.statisticsController ?? StatisticsController();
  }

  @override
  void dispose() {
    if (_ownsSettings) {
      _settingsController.dispose();
    }
    if (_ownsStatistics) {
      _statisticsController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotifierScope<AppSettingsController>(
      notifier: _settingsController,
      child: NotifierScope<StatisticsController>(
        notifier: _statisticsController,
        child: ListenableBuilder(
          listenable: _settingsController,
          builder: (context, _) {
            return MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _settingsController.themeMode,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
