import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The title of the application
  ///
  /// In es, this message translates to:
  /// **'Recibido!'**
  String get appTitle;

  /// Welcome message shown to users
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a Recibido!'**
  String get welcomeMessage;

  /// Title for instruction screen
  ///
  /// In es, this message translates to:
  /// **'Instrucciones'**
  String get instructionTitle;

  /// Instruction text explaining how to use the app
  ///
  /// In es, this message translates to:
  /// **'Toca cualquier carpeta de mes para ver tus comprobantes guardados.\n\nPuedes compartir, eliminar o ver cada comprobante individualmente.\n\n¡Toca la pantalla para continuar!'**
  String get instructionText;

  /// Text telling user to tap screen to continue
  ///
  /// In es, this message translates to:
  /// **'Toca la pantalla para continuar'**
  String get tapToContinue;

  /// Title showing month and year for receipts
  ///
  /// In es, this message translates to:
  /// **'Comprobantes de {month} {year}'**
  String monthReceipts(String month, int year);

  /// Button to delete entire month
  ///
  /// In es, this message translates to:
  /// **'Borrar mes completo'**
  String get deleteMonth;

  /// Title for delete confirmation dialog
  ///
  /// In es, this message translates to:
  /// **'Confirmar borrado'**
  String get confirmDelete;

  /// Confirmation message for deleting month
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres borrar todos los comprobantes de {month} {year}?\n\nEsta acción no se puede deshacer.'**
  String deleteConfirmationMessage(String month, int year);

  /// Cancel button
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Delete button
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get delete;

  /// Message when no receipts found for a month
  ///
  /// In es, this message translates to:
  /// **'No hay comprobantes en este mes'**
  String get noReceipts;

  /// Share button
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get share;

  /// Delete receipt button
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteReceipt;

  /// View receipt button
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get viewReceipt;

  /// Success message when receipt is saved
  ///
  /// In es, this message translates to:
  /// **'Comprobante guardado exitosamente'**
  String get savedSuccessfully;

  /// Error message when saving fails
  ///
  /// In es, this message translates to:
  /// **'Error al guardar el comprobante'**
  String get errorSaving;

  /// Language setting
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Spanish language option
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// English language option
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get english;

  /// January month name
  ///
  /// In es, this message translates to:
  /// **'Enero'**
  String get monthJanuary;

  /// February month name
  ///
  /// In es, this message translates to:
  /// **'Febrero'**
  String get monthFebruary;

  /// March month name
  ///
  /// In es, this message translates to:
  /// **'Marzo'**
  String get monthMarch;

  /// April month name
  ///
  /// In es, this message translates to:
  /// **'Abril'**
  String get monthApril;

  /// May month name
  ///
  /// In es, this message translates to:
  /// **'Mayo'**
  String get monthMay;

  /// June month name
  ///
  /// In es, this message translates to:
  /// **'Junio'**
  String get monthJune;

  /// July month name
  ///
  /// In es, this message translates to:
  /// **'Julio'**
  String get monthJuly;

  /// August month name
  ///
  /// In es, this message translates to:
  /// **'Agosto'**
  String get monthAugust;

  /// September month name
  ///
  /// In es, this message translates to:
  /// **'Septiembre'**
  String get monthSeptember;

  /// October month name
  ///
  /// In es, this message translates to:
  /// **'Octubre'**
  String get monthOctober;

  /// November month name
  ///
  /// In es, this message translates to:
  /// **'Noviembre'**
  String get monthNovember;

  /// December month name
  ///
  /// In es, this message translates to:
  /// **'Diciembre'**
  String get monthDecember;

  /// Title for receipt detail screen
  ///
  /// In es, this message translates to:
  /// **'Detalle del Comprobante'**
  String get receiptDetail;

  /// Label for file name
  ///
  /// In es, this message translates to:
  /// **'Nombre del archivo'**
  String get fileName;

  /// Label for upload date
  ///
  /// In es, this message translates to:
  /// **'Fecha de carga'**
  String get uploadDate;

  /// Title for available actions section
  ///
  /// In es, this message translates to:
  /// **'Acciones disponibles'**
  String get availableActions;

  /// Share file button
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get shareFile;

  /// Open with button
  ///
  /// In es, this message translates to:
  /// **'Abrir con'**
  String get openWith;

  /// Rename file button
  ///
  /// In es, this message translates to:
  /// **'Renombrar'**
  String get renameFile;

  /// Delete file button
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteFile;

  /// Title for rename dialog
  ///
  /// In es, this message translates to:
  /// **'Renombrar archivo'**
  String get renameFileTitle;

  /// Label for new file name input
  ///
  /// In es, this message translates to:
  /// **'Nuevo nombre del archivo'**
  String get newFileName;

  /// Hint text for file name input
  ///
  /// In es, this message translates to:
  /// **'Ej: nuevo_nombre.pdf'**
  String get fileNameHint;

  /// Title for delete confirmation dialog
  ///
  /// In es, this message translates to:
  /// **'Confirmar eliminación'**
  String get confirmDeletion;

  /// Confirmation message for file deletion
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres eliminar \"{fileName}\"?'**
  String confirmDeleteFile(String fileName);

  /// Error message when file name is empty
  ///
  /// In es, this message translates to:
  /// **'El nombre del archivo no puede estar vacío.'**
  String get fileNameEmpty;

  /// Success message when file is renamed
  ///
  /// In es, this message translates to:
  /// **'Archivo renombrado correctamente.'**
  String get fileRenamed;

  /// Success message when file is deleted
  ///
  /// In es, this message translates to:
  /// **'Archivo eliminado correctamente'**
  String get fileDeleted;

  /// Error message when renaming fails
  ///
  /// In es, this message translates to:
  /// **'Error al renombrar: {error}'**
  String errorRenaming(String error);

  /// Error message when deletion fails
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar: {error}'**
  String errorDeleting(String error);

  /// Error message when sharing fails
  ///
  /// In es, this message translates to:
  /// **'Error al compartir archivo: {error}'**
  String errorSharing(String error);

  /// Error message when opening file fails
  ///
  /// In es, this message translates to:
  /// **'Error al abrir el archivo: {error}'**
  String errorOpening(String error);

  /// Error message when file cannot be opened
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir el archivo: {message}'**
  String cannotOpenFile(String message);

  /// Text for sharing file
  ///
  /// In es, this message translates to:
  /// **'Compartir archivo: {fileName}'**
  String shareFileText(String fileName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
