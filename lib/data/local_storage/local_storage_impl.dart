import 'package:bilbank_admin_panel/data/local_storage/local_storage.dart';
import 'package:bilbank_admin_panel/data/local_storage/local_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageImpl implements LocalStorage {
  SharedPreferences? _preferences;

  // Singleton
  static final LocalStorageImpl _instance = LocalStorageImpl._internal();
  factory LocalStorageImpl() => _instance;
  LocalStorageImpl._internal();

  // Başlat
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> clearAll() async {
    if (_preferences == null) return;
    await _preferences!.clear();
  }

  @override
  Future<bool> containsKey(LocalStorageKeys key) async {
    if (_preferences == null) return false;
    return _preferences!.containsKey(key.key);
  }

  @override
Future<T> getValue<T>(LocalStorageKeys key, [T? defaultValue]) async {
  final prefs = _preferences ?? await SharedPreferences.getInstance();

  dynamic value;

  if (T == String) {
    value = prefs.getString(key.key);
  } else if (T == int) {
    value = prefs.getInt(key.key);
  } else if (T == bool) {
    value = prefs.getBool(key.key);
  } else if (T == double) {
    value = prefs.getDouble(key.key);
  } else if (T == List<String>) {
    value = prefs.getStringList(key.key);
  }

  return (value ?? defaultValue) as T;
}

  @override
  Future<void> remove(LocalStorageKeys key) async {
    if (_preferences == null) return;
    await _preferences!.remove(key.key);
  }

  @override
  Future<void> setValue<T>(LocalStorageKeys key, T value) async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    if (value is String) await prefs.setString(key.key, value);
    if (value is int) await prefs.setInt(key.key, value);
    if (value is bool) await prefs.setBool(key.key, value);
    if (value is double) await prefs.setDouble(key.key, value);
    if (value is List<String>) await prefs.setStringList(key.key, value);
  }

}
