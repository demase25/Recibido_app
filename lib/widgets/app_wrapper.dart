import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../services/localization_service.dart';

class AppWrapper extends StatefulWidget {
  final Widget child;
  
  const AppWrapper({Key? key, required this.child}) : super(key: key);
  
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
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
  
  void _changeLocale(Locale locale) async {
    await LocalizationService.setLanguage(locale.languageCode);
    setState(() {
      _currentLocale = locale;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _currentLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          return widget.child;
        },
      ),
    );
  }
}
