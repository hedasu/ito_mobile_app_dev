import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pairly/core/storage/storage_backend.dart';

/// Uygulama genelindeki tema, ses ve titreşim tercihlerini yöneten
/// ve yerel depolamada saklayan [ChangeNotifier] controller'ı.
class AppSettingsController extends ChangeNotifier {
  AppSettingsController({
    ThemeMode initialThemeMode = ThemeMode.system,
    bool initialSoundEnabled = true,
    bool initialHapticEnabled = true,
  })  : _themeMode = initialThemeMode,
        _soundEnabled = initialSoundEnabled,
        _hapticEnabled = initialHapticEnabled;

  static const String _storageKey = 'pairly_app_settings_v1';

  ThemeMode _themeMode;
  bool _soundEnabled;
  bool _hapticEnabled;

  ThemeMode get themeMode => _themeMode;
  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;

  /// Yerel depolamadan kayıtlı tercihleri yükler.
  Future<void> loadSettings() async {
    final raw = await readStorageValue(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final modeStr = decoded['themeMode'] as String?;
        _themeMode = switch (modeStr) {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        };
        _soundEnabled = decoded['soundEnabled'] as bool? ?? true;
        _hapticEnabled = decoded['hapticEnabled'] as bool? ?? true;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _persist();
  }

  Future<void> setSoundEnabled(bool value) async {
    if (_soundEnabled == value) return;
    _soundEnabled = value;
    notifyListeners();
    await _persist();
  }

  Future<void> setHapticEnabled(bool value) async {
    if (_hapticEnabled == value) return;
    _hapticEnabled = value;
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final payload = jsonEncode({
      'themeMode': switch (_themeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      },
      'soundEnabled': _soundEnabled,
      'hapticEnabled': _hapticEnabled,
    });
    await writeStorageValue(_storageKey, payload);
  }
}

