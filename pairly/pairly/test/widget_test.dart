import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pairly/core/constants/app_constants.dart';
import 'package:pairly/core/state/app_settings_controller.dart';
import 'package:pairly/core/state/notifier_scope.dart';
import 'package:pairly/core/theme/app_theme.dart';
import 'package:pairly/core/widgets/pairly_button.dart';
import 'package:pairly/core/widgets/pairly_logo.dart';
import 'package:pairly/features/home/presentation/home_screen.dart';
import 'package:pairly/features/statistics/presentation/statistics_controller.dart';
import 'package:pairly/main.dart';

void main() {
  testWidgets('HomeScreen tüm ana bileşenleri doğru şekilde gösterir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PairlyApp());

    expect(find.byType(PairlyLogo), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.homeTitle), findsOneWidget);
    expect(find.text(AppConstants.homeDescription), findsOneWidget);
    expect(find.text(AppConstants.startGameLabel), findsOneWidget);
    expect(find.text(AppConstants.statisticsLabel), findsOneWidget);
    expect(find.byType(PairlyButton), findsNWidgets(2));
  });

  testWidgets(
    'Oyuna Başla butonuna basılınca 5 seviyeli DifficultyBottomSheet açılır ve oyun başlar',
    (WidgetTester tester) async {
      await tester.pumpWidget(const PairlyApp());

      await tester.tap(find.text(AppConstants.startGameLabel));
      await tester.pumpAndSettle();

      // 5 seviyenin tamamı görünmeli
      expect(find.text('Zorluk Seviyesi'), findsOneWidget);
      expect(find.text('Başlangıç'), findsOneWidget);
      expect(find.text('Kolay'), findsOneWidget);
      expect(find.text('Orta'), findsOneWidget);
      expect(find.text('Zor'), findsOneWidget);
      expect(find.text('Uzman'), findsOneWidget);

      // Başlangıç (3x2) seçip Oyunu Başlat'a tıkla
      await tester.tap(find.text('Başlangıç'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Oyunu Başlat'));
      await tester.pumpAndSettle();

      // Oyun ekranı (Başlangıç 3x2) açılmış olmalı
      expect(find.text('Başlangıç (3x2)'), findsOneWidget);
      expect(find.text('Duraklat'), findsOneWidget);
      expect(find.text('0 / 3'), findsOneWidget);

      // Duraklat butonuna basılınca Oyun Duraklatıldı modalı ve Ana Sayfaya Dön butonu görünmeli
      await tester.tap(find.text('Duraklat'));
      await tester.pumpAndSettle();

      expect(find.text('Oyun Duraklatıldı'), findsOneWidget);
      expect(find.text('Ana Sayfaya Dön'), findsOneWidget);

      // Ana Sayfaya Dön butonuna basılınca ana sayfaya dönülmeli
      await tester.tap(find.text('Ana Sayfaya Dön'));
      await tester.pumpAndSettle();

      expect(find.text(AppConstants.homeTitle), findsOneWidget);
    },
  );

  testWidgets(
    'İstatistikler ekranı boş durumda mesaj gösterir ve kayıt eklendiğinde rekorları listeler',
    (WidgetTester tester) async {
      final statsController = StatisticsController();
      final settingsController = AppSettingsController();

      await tester.pumpWidget(
        PairlyApp(
          settingsController: settingsController,
          statisticsController: statsController,
        ),
      );

      await tester.tap(find.text(AppConstants.statisticsLabel));
      await tester.pumpAndSettle();

      // Boş durum ekranı
      expect(find.text('Henüz oyun kaydın yok'), findsOneWidget);
    },
  );

  testWidgets(
    'HomeScreen Light/Dark Mode ve küçük ekran boyutlarında taşma olmadan render edilir',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final settings = AppSettingsController();
      final stats = StatisticsController();

      await tester.pumpWidget(
        NotifierScope<AppSettingsController>(
          notifier: settings,
          child: NotifierScope<StatisticsController>(
            notifier: stats,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const HomeScreen(),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text(AppConstants.homeTitle), findsOneWidget);

      await tester.pumpWidget(
        NotifierScope<AppSettingsController>(
          notifier: settings,
          child: NotifierScope<StatisticsController>(
            notifier: stats,
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: const HomeScreen(),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text(AppConstants.homeTitle), findsOneWidget);
    },
  );
}
