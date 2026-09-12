import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/community_post.dart';
import '../models/fruit.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _kEmail = 'auth_email';
  static const _kPassword = 'auth_password';
  static const _kIsLoggedIn = 'auth_is_logged_in';
  static const _kOnboarded = 'onboarding_complete';
  static const _kUserName = 'user_name';
  static const _kTopPriority = 'user_top_priority';
  static const _kLocation = 'user_location';
  static const _kReminders = 'user_reminders_enabled';
  static const _kBiometric = 'settings_biometric';
  static const _kNotifications = 'settings_notifications';
  static const _kFruits = 'data_fruits';
  static const _kPosts = 'data_community_posts';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _sp async => _prefs ??= await SharedPreferences.getInstance();

  // ---------- Auth / credentials ----------

  Future<void> saveCredentials({required String email, required String password}) async {
    final sp = await _sp;
    await sp.setString(_kEmail, email);
    await sp.setString(_kPassword, password);
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final sp = await _sp;
    final email = sp.getString(_kEmail);
    final password = sp.getString(_kPassword);
    if (email == null || password == null) return null;
    return {'email': email, 'password': password};
  }

  Future<void> setLoggedIn(bool value) async {
    final sp = await _sp;
    await sp.setBool(_kIsLoggedIn, value);
  }

  Future<bool> isLoggedIn() async {
    final sp = await _sp;
    return sp.getBool(_kIsLoggedIn) ?? false;
  }

  Future<void> clearSession() async {
    final sp = await _sp;
    await sp.setBool(_kIsLoggedIn, false);
    // Credentials themselves are kept so "Login" can pre-fill / re-auth;
    // only the active session flag is cleared on logout.
  }

  Future<void> wipeAll() async {
    final sp = await _sp;
    await sp.clear();
  }

  // ---------- Onboarding / profile ----------

  Future<void> setOnboarded(bool value) async {
    final sp = await _sp;
    await sp.setBool(_kOnboarded, value);
  }

  Future<bool> isOnboarded() async {
    final sp = await _sp;
    return sp.getBool(_kOnboarded) ?? false;
  }

  Future<void> saveUserName(String name) async {
    final sp = await _sp;
    await sp.setString(_kUserName, name);
  }

  Future<String?> getUserName() async {
    final sp = await _sp;
    return sp.getString(_kUserName);
  }

  Future<void> saveTopPriority(String value) async {
    final sp = await _sp;
    await sp.setString(_kTopPriority, value);
  }

  Future<String?> getTopPriority() async {
    final sp = await _sp;
    return sp.getString(_kTopPriority);
  }

  Future<void> saveLocation(String value) async {
    final sp = await _sp;
    await sp.setString(_kLocation, value);
  }

  Future<String?> getLocation() async {
    final sp = await _sp;
    return sp.getString(_kLocation);
  }

  Future<void> saveReminders(bool value) async {
    final sp = await _sp;
    await sp.setBool(_kReminders, value);
  }

  Future<bool> getReminders() async {
    final sp = await _sp;
    return sp.getBool(_kReminders) ?? false;
  }

  Future<void> saveBiometric(bool value) async {
    final sp = await _sp;
    await sp.setBool(_kBiometric, value);
  }

  Future<bool> getBiometric() async {
    final sp = await _sp;
    return sp.getBool(_kBiometric) ?? true;
  }

  Future<void> saveNotifications(bool value) async {
    final sp = await _sp;
    await sp.setBool(_kNotifications, value);
  }

  Future<bool> getNotifications() async {
    final sp = await _sp;
    return sp.getBool(_kNotifications) ?? true;
  }

  // ---------- Fruits ----------

  Future<void> saveFruits(List<Fruit> fruits) async {
    final sp = await _sp;
    final jsonList = fruits.map((f) => f.toJson()).toList();
    await sp.setString(_kFruits, jsonEncode(jsonList));
  }

  Future<List<Fruit>> loadFruits() async {
    final sp = await _sp;
    final raw = sp.getString(_kFruits);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Fruit.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Corrupted/old-format data shouldn't crash the app on launch.
      return [];
    }
  }

    Future<void> savePosts(List<CommunityPost> posts) async {
    final sp = await _sp;
    final jsonList = posts.map((p) => p.toJson()).toList();
    await sp.setString(_kPosts, jsonEncode(jsonList));
  }

  Future<List<CommunityPost>?> loadPosts() async {
    final sp = await _sp;
    final raw = sp.getString(_kPosts);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => CommunityPost.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }
}
