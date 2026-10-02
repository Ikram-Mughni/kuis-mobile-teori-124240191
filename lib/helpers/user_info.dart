import 'package:shared_preferences/shared_preferences.dart';

// Utilitas pengelola sesi dan data lokal pengguna
class UserInfo {
  static const String _tokenKey = "user_token";
  static const String _userIdKey = "user_id";
  static const String _userNameKey = "user_name";

  // Menyimpan token otentikasi
  static Future<bool> setToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(_tokenKey, token);
  }

  // Mengambil token otentikasi
  static Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_tokenKey);
  }

  // Menyimpan data identitas pengguna
  static Future<bool> setUserData(String id, String name) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(_userIdKey, id);
    return pref.setString(_userNameKey, name);
  }

  // Mengambil ID pengguna
  static Future<String?> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_userIdKey);
  }

  // Mengambil nama pengguna
  static Future<String?> getUserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_userNameKey);
  }

  // Menghapus data sesi saat logout
  static Future<bool> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
  }
}
