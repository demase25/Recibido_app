import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class LanguageProvider extends InheritedWidget {
  final Locale currentLocale;
  final Function(Locale) changeLanguage;
  
  const LanguageProvider({
    Key? key,
    required this.currentLocale,
    required this.changeLanguage,
    required Widget child,
  }) : super(key: key, child: child);
  
  static LanguageProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageProvider>();
  }
  
  @override
  bool updateShouldNotify(LanguageProvider oldWidget) {
    return currentLocale != oldWidget.currentLocale;
  }
}
