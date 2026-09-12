import 'package:flutter/material.dart';

import '../data/community_seed_data.dart';
import '../models/community_post.dart';
import '../models/fruit.dart';
import '../services/storage_service.dart';

enum AuthResult { success, invalidCredentials, noAccount, accountExists }

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService.instance;

  bool _initialized = false;
  bool get initialized => _initialized;

  // ---- Auth / onboarding ----
  bool isLoggedIn = false;
  String userName = 'Fruit Lover';
  String topPriority = '';
  String location = '';
  bool remindersEnabled = false;

  // ---- Profile toggles ----
  bool biometricEnabled = true;
  bool notificationsEnabled = true;
  int notificationCount = 1;

  // ---- Fruits ----
  final List<Fruit> myFruits = [];

  // ---- Community feed ----
  final List<CommunityPost> posts = [];

  /// Loads every persisted value from local storage. Called once at app
  /// startup before the first screen decides where to route the user.
  Future<void> init() async {
    isLoggedIn = await _storage.isLoggedIn();
    userName = await _storage.getUserName() ?? userName;
    topPriority = await _storage.getTopPriority() ?? '';
    location = await _storage.getLocation() ?? '';
    remindersEnabled = await _storage.getReminders();
    biometricEnabled = await _storage.getBiometric();
    notificationsEnabled = await _storage.getNotifications();

    myFruits
      ..clear()
      ..addAll(await _storage.loadFruits());

    final savedPosts = await _storage.loadPosts();
    posts
      ..clear()
      ..addAll(savedPosts ?? buildSeedCommunityPosts());
    if (savedPosts == null) {
      await _storage.savePosts(posts);
    }

    _initialized = true;
    notifyListeners();
  }

  Future<bool> hasOnboarded() => _storage.isOnboarded();

  // ---------- Auth ----------

  /// Registers a new local account. In this offline demo, "registering"
  /// just means saving the email/password pair on-device so the same
  /// credentials can be used to log back in later.
  Future<AuthResult> register({
    required String email,
    required String password,
  }) async {
    final existing = await _storage.getSavedCredentials();
    if (existing != null && existing['email'] == email) {
      return AuthResult.accountExists;
    }
    await _storage.saveCredentials(email: email, password: password);
    await _storage.setLoggedIn(true);
    isLoggedIn = true;
    notifyListeners();
    return AuthResult.success;
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final saved = await _storage.getSavedCredentials();
    if (saved == null) return AuthResult.noAccount;
    if (saved['email'] != email || saved['password'] != password) {
      return AuthResult.invalidCredentials;
    }
    await _storage.setLoggedIn(true);
    isLoggedIn = true;
    notifyListeners();
    return AuthResult.success;
  }

  /// Skips real auth (used by the "Continue with Google/Apple" buttons,
  /// which are visual placeholders since no backend is wired up).
  Future<void> loginWithProvider() async {
    await _storage.setLoggedIn(true);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.clearSession();
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _storage.setOnboarded(true);
  }

  // ---------- Profile / onboarding data ----------

  void setUserName(String name) {
    userName = name;
    _storage.saveUserName(name);
    notifyListeners();
  }

  void setPriority(String priority) {
    topPriority = priority;
    _storage.saveTopPriority(priority);
    notifyListeners();
  }

  void setLocation(String loc) {
    location = loc;
    _storage.saveLocation(loc);
    notifyListeners();
  }

  void setReminders(bool value) {
    remindersEnabled = value;
    _storage.saveReminders(value);
    notifyListeners();
  }

  void toggleBiometric(bool value) {
    biometricEnabled = value;
    _storage.saveBiometric(value);
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    _storage.saveNotifications(value);
    notifyListeners();
  }

  // ---------- Fruits (persisted on every change) ----------

  void addFruit(Fruit fruit) {
    myFruits.add(fruit);
    _storage.saveFruits(myFruits);
    notifyListeners();
  }

  void addCareTaskToFruit(String fruitId, CareTask task) {
    final fruit = myFruits.firstWhere((f) => f.id == fruitId);
    fruit.tasks.add(task);
    _storage.saveFruits(myFruits);
    notifyListeners();
  }

  void removeFruit(String fruitId) {
    myFruits.removeWhere((f) => f.id == fruitId);
    _storage.saveFruits(myFruits);
    notifyListeners();
  }

  // ---------- Community posts (persisted on every change) ----------

  void addPost(CommunityPost post) {
    posts.insert(0, post);
    _storage.savePosts(posts);
    notifyListeners();
  }

  // ---- Nursery (static catalogue, dynamic cart - session only) ----
  final List<NurseryPlant> nursery = [
    NurseryPlant(
      name: 'Banana',
      category: 'Indoor',
      price: 20,
      icon: Icons.eco,
      color: const Color(0xFF6FA469),
    ),
    NurseryPlant(
      name: 'Mango',
      category: 'Indoor/Outdoor',
      price: 25,
      icon: Icons.eco,
      color: const Color(0xFF7CB37B),
    ),
    NurseryPlant(
      name: 'Watermelon',
      category: 'Indoor/Outdoor',
      price: 25,
      icon: Icons.eco,
      color: const Color(0xFF5F9C5B),
    ),
    NurseryPlant(
      name: 'Papaya',
      category: 'Indoor/Outdoor',
      price: 25,
      icon: Icons.eco,
      color: const Color(0xFF6FA469),
    ),
    NurseryPlant(
      name: 'Banana',
      category: 'Outdoor',
      price: 20,
      icon: Icons.eco,
      color: const Color(0xFF7CB37B),
    ),
    NurseryPlant(
      name: 'Mango',
      category: 'Outdoor',
      price: 25,
      icon: Icons.eco,
      color: const Color(0xFF5F9C5B),
    ),
  ];

  final List<NurseryPlant> cart = [];

  void addToCart(NurseryPlant plant) {
    cart.add(plant);
    notifyListeners();
  }

  void incrementCartItem(NurseryPlant plant) {
    cart.add(plant);
    notifyListeners();
  }

  void decrementCartItem(NurseryPlant plant) {
    final idx = cart.indexWhere(
      (p) => p.name == plant.name && p.category == plant.category,
    );
    if (idx != -1) {
      cart.removeAt(idx);
      notifyListeners();
    }
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  double get cartSubtotal => cart.fold(0.0, (sum, p) => sum + p.price);
  double get deliveryFee => cart.isEmpty ? 0 : 5.0;
  double get cartTotal => cartSubtotal + deliveryFee;
}
