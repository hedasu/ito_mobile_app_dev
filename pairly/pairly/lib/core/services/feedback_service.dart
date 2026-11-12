import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform desteğine göre ses ve dokunsal (haptic) geri bildirim servisi.
///
/// Not: Harici ses paketi kullanılmadığından Flutter'ın yerleşik [SystemSound]
/// ve [HapticFeedback] API'leri kullanılır. Web ve masaüstü platformlarda
/// işletim sistemi/tarayıcı kısıtlamaları nedeniyle haptik ve sistem sesleri
/// sessizce yoksayılabilir; bu durumlarda hata fırlatmadan güvenli şekilde çalışır.
abstract final class FeedbackService {
  /// Mevcut platformda dokunsal geri bildirimin (titreşim) fiziksel olarak
  /// desteklenip desteklenmediğini döndürür.
  static bool get isHapticSupportedOnPlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Kart çevrildiğinde hafif ses ve dokunsal geri bildirim verir.
  static Future<void> playFlip({
    required bool soundEnabled,
    required bool hapticEnabled,
  }) async {
    if (soundEnabled) {
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
    if (hapticEnabled && isHapticSupportedOnPlatform) {
      try {
        await HapticFeedback.selectionClick();
      } catch (_) {}
    }
  }

  /// İki kart eşleştiğinde orta şiddette geri bildirim verir.
  static Future<void> playMatch({
    required bool soundEnabled,
    required bool hapticEnabled,
  }) async {
    if (soundEnabled) {
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
    if (hapticEnabled && isHapticSupportedOnPlatform) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  /// Yanlış eşleşmede hafif uyarı titreşimi verir.
  static Future<void> playMismatch({
    required bool soundEnabled,
    required bool hapticEnabled,
  }) async {
    if (hapticEnabled && isHapticSupportedOnPlatform) {
      try {
        await HapticFeedback.lightImpact();
      } catch (_) {}
    }
  }

  /// Oyun kazanıldığında kutlama geri bildirimi verir.
  static Future<void> playWin({
    required bool soundEnabled,
    required bool hapticEnabled,
  }) async {
    if (soundEnabled) {
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
    if (hapticEnabled && isHapticSupportedOnPlatform) {
      try {
        await HapticFeedback.heavyImpact();
      } catch (_) {}
    }
  }
}

