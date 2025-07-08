import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  // SharedPreferences keys
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (isLoggedIn) {
        final userJson = prefs.getString(_userKey);
        if (userJson != null) {
          final userMap = json.decode(userJson) as Map<String, dynamic>;
          _currentUser = User.fromJson(userMap);
          _isLoggedIn = true;
        }
      }
    } catch (e) {
      // Error loading user data
      _currentUser = null;
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register new user (local)
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate registration delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if user already exists (simple email check)
      if (await _userExists(email)) {
        _isLoading = false;
        notifyListeners();
        return false; // User already exists
      }

      // Create new user
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      // Save user data
      await _saveUserData(user);
      await _saveCredentials(email, password);

      _currentUser = user;
      _isLoggedIn = true;

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user (local)
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate login delay
      await Future.delayed(const Duration(seconds: 1));

      // Check credentials
      if (await _validateCredentials(email, password)) {
        // Load user data from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final userJson = prefs.getString(_userKey);
        
        if (userJson != null) {
          final userMap = json.decode(userJson) as Map<String, dynamic>;
          _currentUser = User.fromJson(userMap);
        }
        
        _isLoggedIn = true;
        await prefs.setBool(_isLoggedInKey, true);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      // DON'T remove user data - keep it for next login!
      // await prefs.remove(_userKey);

      _currentUser = null;
      _isLoggedIn = false;

    } catch (e) {
      // Error during logout
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? profileImagePath,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        email: email,
        profileImagePath: profileImagePath,
      );

      await _saveUserData(updatedUser);
      _currentUser = updatedUser;

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update user stats (favorites, uploads)
  Future<void> updateUserStats({int? favoriteCount, int? uploadCount}) async {
    if (_currentUser == null) return;

    try {
      final updatedUser = _currentUser!.copyWith(
        favoriteCount: favoriteCount,
        uploadCount: uploadCount,
      );

      await _saveUserData(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();

    } catch (e) {
      // Error updating stats
    }
  }

  // Helper methods
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_credentials_$email', password);
  }

  Future<bool> _validateCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString('user_credentials_$email');
    return storedPassword == password;
  }

  Future<bool> _userExists(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_credentials_$email');
  }



  // Check if email is valid
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Check if password is strong enough
  bool isValidPassword(String password) {
    return password.length >= 6;
  }
} 