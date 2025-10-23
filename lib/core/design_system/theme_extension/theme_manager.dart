import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum representing different theme modes
enum ThemeModeEnum {
  light,
  dark,
  system;

  /// Convert ThemeModeEnum to Flutter's ThemeMode
  ThemeMode toThemeMode() {
    switch (this) {
      case ThemeModeEnum.light:
        return ThemeMode.light;
      case ThemeModeEnum.dark:
        return ThemeMode.dark;
      case ThemeModeEnum.system:
        return ThemeMode.system;
    }
  }

  /// Get the string name of the theme mode
  String get name {
    switch (this) {
      case ThemeModeEnum.light:
        return 'Light';
      case ThemeModeEnum.dark:
        return 'Dark';
      case ThemeModeEnum.system:
        return 'System';
    }
  }
}

/// Provider implementation for theme management
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme';
  ThemeModeEnum _themeMode = ThemeModeEnum.system;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadTheme();
  }

  /// Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    
    if (themeIndex != null) {
      _themeMode = ThemeModeEnum.values[
        themeIndex.clamp(0, ThemeModeEnum.values.length - 1)
      ];
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  /// Get current theme mode
  ThemeModeEnum get themeMode => _themeMode;
  
  /// Get Flutter ThemeMode for MaterialApp
  ThemeMode get flutterThemeMode => _themeMode.toThemeMode();
  
  /// Check if the theme provider is initialized
  bool get isInitialized => _isInitialized;
  
  /// Check if dark mode is active (including system dark mode)
  bool get isDarkMode {
    if (_themeMode == ThemeModeEnum.system) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeModeEnum.dark;
  }

  /// Set theme mode and save to SharedPreferences
  Future<void> setThemeMode(ThemeModeEnum mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }
}

/// Extension method to access theme provider easily
extension ThemeProviderExtension on BuildContext {
  ThemeProvider get themeProvider => Provider.of<ThemeProvider>(this, listen: false);
  ThemeModeEnum get themeMode => Provider.of<ThemeProvider>(this, listen: true).themeMode;
  bool get isDarkMode => Provider.of<ThemeProvider>(this, listen: true).isDarkMode;
}
