import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/month_detail_screen.dart';
import 'screens/comprobante_detail_screen.dart';
import 'screens/saved_confirmation_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(RecibidoApp());
}

class RecibidoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recibido!',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        fontFamily: 'Nunito',
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
