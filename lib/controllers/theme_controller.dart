import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'app_theme_mode';

  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  /// Load theme preference from storage
  Future<void> _loadThemeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      _isDarkMode.value = isDark;
      Get.changeThemeMode(themeMode);
    } catch (e) {
      log('Error loading theme: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    try {
      _isDarkMode.value = !_isDarkMode.value;
      Get.changeThemeMode(themeMode);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode.value);
    } catch (e) {
      log('Error saving theme: $e');
    }
  }

  /// Set theme mode directly
  Future<void> setThemeMode(bool isDark) async {
    try {
      _isDarkMode.value = isDark;
      Get.changeThemeMode(themeMode);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      log('Error setting theme: $e');
    }
  }
}