import 'package:shared_preferences/shared_preferences.dart';

class PrefDb {
  static const String _PREF_TOKEN = 'pref_token';
  final SharedPreferences prefs;

  PrefDb(this.prefs);

  Future<void> deleteToken() async {
    prefs.remove(_PREF_TOKEN);
  }

  Future<String> getToken() async {
    return prefs.getString(_PREF_TOKEN) ?? '';
  }

  Future<bool> hasToken() async {
    return prefs.containsKey(_PREF_TOKEN);
  }

  Future<void> saveToken(String token) async {
    prefs.setString(_PREF_TOKEN, token);
  }

  Future<void> saveStringData(String key, String value) async {
    if (key.isNotEmpty) {
      prefs.setString(key, value);
    }
  }

  Future<String?> getStringData(String key) async {
    return prefs.getString(key);
  }

  Future<void> deleteData(String key) async {
    if (key.isNotEmpty) {
      prefs.remove(key);
    }
  }

  Future<bool> deleteAll() => prefs.clear();
}
