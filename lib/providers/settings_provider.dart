import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // Settings keys
  static const String _notificationsKey = 'notifications_enabled';
  static const String _autoRefreshKey = 'auto_refresh_enabled';
  static const String _saveToGalleryKey = 'save_to_gallery_enabled';

  // Settings values
  bool _notificationsEnabled = true;
  bool _autoRefreshEnabled = true;
  bool _saveImageToGallery = false;

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoRefreshEnabled => _autoRefreshEnabled;
  bool get saveImageToGallery => _saveImageToGallery;

  SettingsProvider() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      _autoRefreshEnabled = prefs.getBool(_autoRefreshKey) ?? true;
      _saveImageToGallery = prefs.getBool(_saveToGalleryKey) ?? false;
      
      notifyListeners();
    } catch (e) {
      // Error loading settings - use defaults
    }
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_notificationsKey, _notificationsEnabled);
      await prefs.setBool(_autoRefreshKey, _autoRefreshEnabled);
      await prefs.setBool(_saveToGalleryKey, _saveImageToGallery);
    } catch (e) {
      // Error saving settings
    }
  }

  // Update notifications setting
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }

  // Update auto refresh setting
  Future<void> setAutoRefreshEnabled(bool enabled) async {
    _autoRefreshEnabled = enabled;
    notifyListeners();
    await _saveSettings();
  }

  // Update save to gallery setting
  Future<void> setSaveImageToGallery(bool enabled) async {
    _saveImageToGallery = enabled;
    notifyListeners();
    await _saveSettings();
  }

  // Reset all settings to defaults
  Future<void> resetToDefaults() async {
    _notificationsEnabled = true;
    _autoRefreshEnabled = true;
    _saveImageToGallery = false;
    
    notifyListeners();
    await _saveSettings();
  }

  // Clear all settings (for app reset)
  Future<void> clearAllSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(_notificationsKey);
      await prefs.remove(_autoRefreshKey);
      await prefs.remove(_saveToGalleryKey);
      
      // Reset to defaults
      await resetToDefaults();
    } catch (e) {
      // Error clearing settings
    }
  }
} 