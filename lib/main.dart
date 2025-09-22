import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/month_detail_screen.dart';
import 'screens/comprobante_detail_screen.dart';
import 'screens/saved_confirmation_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants/app_colors.dart';
import 'services/localization_service.dart';
import 'l10n/app_localizations.dart';
import 'widgets/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await LocalizationService.initialize();
  runApp(RecibidoApp());
}

class RecibidoApp extends StatefulWidget {
  @override
  _RecibidoAppState createState() => _RecibidoAppState();
}

class _RecibidoAppState extends State<RecibidoApp> {
  Locale _currentLocale = LocalizationService.currentLocale;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentLocale();
  }
  
  Future<void> _loadCurrentLocale() async {
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
        title: 'Recibido!',
        locale: _currentLocale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Nunito',
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            elevation: 4,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/monthDetail': (context) => MonthDetailScreen(),
          '/comprobanteDetail': (context) => ComprobanteDetailScreen(),
          '/savedConfirmation': (context) => SavedConfirmationScreen(),
        },
      ),
    );
  }
}
