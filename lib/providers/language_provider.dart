import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LanguageProvider with ChangeNotifier {
  Locale? _locale;
  
  // Returns the current locale or the system locale if not set
  Locale get locale {
    if (_locale != null) return _locale!;
    
    // Get system locale
    final systemLocale = ui.window.locale;
    
    // Check if the system locale is supported
    if (['en', 'fr', 'es', 'de', 'ar'].contains(systemLocale.languageCode)) {
      return systemLocale;
    }
    
    // Fallback to English
    return const Locale('en', '');
  }
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
  
  // Clear explicit locale setting to use system default
  void useSystemLocale() {
    _locale = null;
    notifyListeners();
  }
} 