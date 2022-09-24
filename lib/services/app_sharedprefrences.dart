import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  static saveToken(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static readToken(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static removeToken(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
