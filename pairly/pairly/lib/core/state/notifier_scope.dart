import 'package:flutter/widgets.dart';

/// Harici paket kullanmadan [ChangeNotifier] tabanlı controller'ları
/// widget ağacında alt bileşenlere sağlayan ve dinleyen temel yapı.
class NotifierScope<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const NotifierScope({
    super.key,
    required T notifier,
    required super.child,
  }) : super(notifier: notifier);

  /// Widget ağacındaki ilgili [T] notifier nesnesini dinleyerek döndürür.
  /// Notifier güncellendiğinde bu metodu çağıran widget yeniden çizilir.
  static T watch<T extends ChangeNotifier>(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<NotifierScope<T>>();
    assert(
      scope != null && scope.notifier != null,
      'Widget ağacında NotifierScope<$T> bulunamadı.',
    );
    return scope!.notifier!;
  }

  /// Widget ağacındaki ilgili [T] notifier nesnesini yeniden çizim
  /// tetiklemeden (ör. buton tıklamalarında) döndürür.
  static T read<T extends ChangeNotifier>(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<NotifierScope<T>>();
    final scope = element?.widget as NotifierScope<T>?;
    assert(
      scope != null && scope.notifier != null,
      'Widget ağacında NotifierScope<$T> bulunamadı.',
    );
    return scope!.notifier!;
  }
}

