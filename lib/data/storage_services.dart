import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class StorageService {
  static const String _userKey = 'user_data';
  
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  // Save user data
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJSON());
    await _prefs.setString(_userKey, userJson);
  }
  
  // Get stored user
  Future<User?> getStoredUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    
    try {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      
      // Check if token is still valid
      if (User.isStoredTokenValid(userData)) {
        return User.fromJson(userData);
      } else {
        // Token expired, clear stored data
        await clearUser();
        return null;
      }
    } catch (e) {
      // Invalid stored data, clear it
      await clearUser();
      return null;
    }
  }
  
  // Clear stored user data
  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final user = await getStoredUser();
    return user != null;
  }
}