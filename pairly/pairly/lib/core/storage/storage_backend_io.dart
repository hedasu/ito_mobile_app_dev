import 'dart:convert';
import 'dart:io';

/// Mobil ve Masaüstü (dart:io) için yerel JSON dosya depolaması.
final Map<String, String> _fallbackMemoryStore = {};

File _resolveStorageFile() {
  final home = Platform.environment['APPDATA'] ??
      Platform.environment['HOME'] ??
      Directory.systemTemp.path;
  final dir = Directory('$home${Platform.pathSeparator}.pairly_data');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  return File('${dir.path}${Platform.pathSeparator}pairly_storage.json');
}

Future<String?> readStorageValue(String key) async {
  try {
    final file = _resolveStorageFile();
    if (!file.existsSync()) {
      return _fallbackMemoryStore[key];
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return _fallbackMemoryStore[key];
    }
    final decoded = jsonDecode(content);
    if (decoded is Map<String, dynamic>) {
      final val = decoded[key];
      return val is String ? val : _fallbackMemoryStore[key];
    }
  } catch (_) {
    // Test veya kısıtlı dosya sistemlerinde bellek içi yedeği kullan
  }
  return _fallbackMemoryStore[key];
}

Future<void> writeStorageValue(String key, String value) async {
  _fallbackMemoryStore[key] = value;
  try {
    final file = _resolveStorageFile();
    Map<String, dynamic> data = {};
    if (file.existsSync()) {
      final existing = await file.readAsString();
      if (existing.trim().isNotEmpty) {
        final decoded = jsonDecode(existing);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }
    }
    data[key] = value;
    await file.writeAsString(jsonEncode(data));
  } catch (_) {
    // Dosya yazımı başarısız olursa bellek içi kayıt korunur
  }
}

