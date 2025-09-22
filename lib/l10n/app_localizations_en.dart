// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Received!';

  @override
  String get welcomeMessage => 'Welcome to Received!';

  @override
  String get instructionTitle => 'Instructions';

  @override
  String get instructionText =>
      'Tap any month folder to view your saved receipts.\n\nYou can share, delete or view each receipt individually.\n\nTap the screen to continue!';

  @override
  String get tapToContinue => 'Tap the screen to continue';

  @override
  String monthReceipts(String month, int year) {
    return 'Receipts for $month $year';
  }

  @override
  String get deleteMonth => 'Delete entire month';

  @override
  String get confirmDelete => 'Confirm deletion';

  @override
  String deleteConfirmationMessage(String month, int year) {
    return 'Are you sure you want to delete all receipts from $month $year?\n\nThis action cannot be undone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get noReceipts => 'No receipts found for this month';

  @override
  String get share => 'Share';

  @override
  String get deleteReceipt => 'Delete';

  @override
  String get viewReceipt => 'View';

  @override
  String get savedSuccessfully => 'Receipt saved successfully';

  @override
  String get errorSaving => 'Error saving receipt';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get receiptDetail => 'Receipt Details';

  @override
  String get fileName => 'File name';

  @override
  String get uploadDate => 'Upload date';

  @override
  String get availableActions => 'Available actions';

  @override
  String get shareFile => 'Share';

  @override
  String get openWith => 'Open with';

  @override
  String get renameFile => 'Rename';

  @override
  String get deleteFile => 'Delete';

  @override
  String get renameFileTitle => 'Rename file';

  @override
  String get newFileName => 'New file name';

  @override
  String get fileNameHint => 'E.g: new_name.pdf';

  @override
  String get confirmDeletion => 'Confirm deletion';

  @override
  String confirmDeleteFile(String fileName) {
    return 'Are you sure you want to delete \"$fileName\"?';
  }

  @override
  String get fileNameEmpty => 'The file name cannot be empty.';

  @override
  String get fileRenamed => 'File renamed successfully.';

  @override
  String get fileDeleted => 'File deleted successfully';

  @override
  String errorRenaming(String error) {
    return 'Error renaming: $error';
  }

  @override
  String errorDeleting(String error) {
    return 'Error deleting: $error';
  }

  @override
  String errorSharing(String error) {
    return 'Error sharing file: $error';
  }

  @override
  String errorOpening(String error) {
    return 'Error opening file: $error';
  }

  @override
  String cannotOpenFile(String message) {
    return 'Could not open file: $message';
  }

  @override
  String shareFileText(String fileName) {
    return 'Share file: $fileName';
  }
}
