import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys for storing user data
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userNoHpKey = 'user_nohp';
  static const String _userNikKey = 'user_nik';
  static const String _userAlamatKey = 'user_alamat';

  // Save user profile data
  static Future<void> saveUserProfile(Map<String, dynamic> user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, user['id']);
    await prefs.setString(_userNameKey, user['name']);
    await prefs.setString(_userEmailKey, user['email']);
    await prefs.setString(_userNoHpKey, user['no_hp']);
    await prefs.setString(_userNikKey, user['nik_ktp']);
    await prefs.setString(_userAlamatKey, user['alamat']);
  }

  // Getters for user data
  static Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<String?> getUserNoHp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNoHpKey);
  }

  static Future<String?> getUserNik() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNikKey);
  }

  static Future<String?> getUserAlamat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userAlamatKey);
  }

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userIdKey);
  }

  // Clear user data on logout
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNoHpKey);
    await prefs.remove(_userNikKey);
    await prefs.remove(_userAlamatKey);
  }
}
