import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/month_detail_screen.dart';
import 'screens/comprobante_detail_screen.dart';
import 'screens/saved_confirmation_screen.dart';
import 'screens/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(RecibidoApp());
}

class RecibidoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recibido!',
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
      initialRoute: '/splash',
      routes: {
        '/': (context) => HomeScreen(),
        '/monthDetail': (context) => MonthDetailScreen(),
        '/comprobanteDetail': (context) => ComprobanteDetailScreen(),
        '/savedConfirmation': (context) => SavedConfirmationScreen(),
        '/splash': (context) => SplashScreen(),
      },
    );
  }
}
