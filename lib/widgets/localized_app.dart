import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../services/localization_service.dart';
import 'language_provider.dart';

class LocalizedApp extends StatefulWidget {
  final Widget child;
  
  const LocalizedApp({Key? key, required this.child}) : super(key: key);
  
  @override
  _LocalizedAppState createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  Locale _currentLocale = LocalizationService.currentLocale;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentLocale();
  }
  
  Future<void> _loadCurrentLocale() async {
    await LocalizationService.initialize();
    setState(() {
      _currentLocale = LocalizationService.currentLocale;
    });
  }
  
  void changeLanguage(Locale locale) async {
    await LocalizationService.setLanguage(locale.languageCode);
    setState(() {
      _currentLocale = locale;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return LanguageProvider(
      currentLocale: _currentLocale,
      changeLanguage: changeLanguage,
      child: MaterialApp(
        locale: _currentLocale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return widget.child;
          },
        ),
      ),
    );
  }
}
