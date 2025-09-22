import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _languageKey = 'selected_language';
  
  static const List<Locale> supportedLocales = [
    Locale('es', ''), // Español
    Locale('en', ''), // Inglés
  ];
  
  static Locale _currentLocale = Locale('es', '');
  
  static Locale get currentLocale => _currentLocale;
  
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'es';
    _currentLocale = Locale(languageCode, '');
  }
  
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    _currentLocale = Locale(languageCode, '');
  }
  
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Español';
    }
  }
  
  static String getCurrentLanguageName() {
    return getLanguageName(_currentLocale.languageCode);
  }
}
