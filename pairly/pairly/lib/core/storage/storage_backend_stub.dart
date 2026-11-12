/// Bellek içi yedek depolama (stub).
final Map<String, String> _memoryStore = {};

Future<String?> readStorageValue(String key) async => _memoryStore[key];

Future<void> writeStorageValue(String key, String value) async {
  _memoryStore[key] = value;
}

