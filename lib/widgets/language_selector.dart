import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/localization_service.dart';
import '../constants/app_colors.dart';
import 'language_provider.dart';

class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = LanguageProvider.of(context);
    
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.language,
        color: AppColors.textPrimary,
      ),
      tooltip: l10n.language,
      onSelected: (String languageCode) async {
        await LocalizationService.setLanguage(languageCode);
        // Cambiar el idioma inmediatamente usando el provider
        if (languageProvider != null) {
          languageProvider.changeLanguage(Locale(languageCode));
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'es',
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.blue),
              SizedBox(width: 8),
              Text(l10n.spanish),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.red),
              SizedBox(width: 8),
              Text(l10n.english),
            ],
          ),
        ),
      ],
    );
  }
}
