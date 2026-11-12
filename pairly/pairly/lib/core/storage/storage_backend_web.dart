import 'dart:js_interop';

@JS('window.localStorage.getItem')
external JSString? _localStorageGetItem(JSString key);

@JS('window.localStorage.setItem')
external void _localStorageSetItem(JSString key, JSString value);

final Map<String, String> _webFallbackStore = {};

Future<String?> readStorageValue(String key) async {
  try {
    final result = _localStorageGetItem(key.toJS);
    return result?.toDart ?? _webFallbackStore[key];
  } catch (_) {
    return _webFallbackStore[key];
  }
}

Future<void> writeStorageValue(String key, String value) async {
  _webFallbackStore[key] = value;
  try {
    _localStorageSetItem(key.toJS, value.toJS);
  } catch (_) {}
}

