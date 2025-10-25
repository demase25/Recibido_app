// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Recibido!';

  @override
  String get welcomeMessage => 'Bienvenido a Recibido!';

  @override
  String get instructionTitle => 'Instrucciones';

  @override
  String get instructionText =>
      'Toca cualquier carpeta de mes para ver tus comprobantes guardados.\n\nPuedes compartir, eliminar o ver cada comprobante individualmente.\n\n¡Toca la pantalla para continuar!';

  @override
  String get tapToContinue => 'Toca la pantalla para continuar';

  @override
  String monthReceipts(String month, int year) {
    return 'Comprobantes de $month $year';
  }

  @override
  String get deleteMonth => 'Borrar mes completo';

  @override
  String get confirmDelete => 'Confirmar borrado';

  @override
  String deleteConfirmationMessage(String month, int year) {
    return '¿Estás seguro de que quieres borrar todos los comprobantes de $month $year?\n\nEsta acción no se puede deshacer.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Borrar';

  @override
  String get noReceipts => 'No hay comprobantes en este mes';

  @override
  String get share => 'Compartir';

  @override
  String get deleteReceipt => 'Eliminar';

  @override
  String get viewReceipt => 'Ver';

  @override
  String get savedSuccessfully => 'Comprobante guardado exitosamente';

  @override
  String get errorSaving => 'Error al guardar el comprobante';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Febrero';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Mayo';

  @override
  String get monthJune => 'Junio';

  @override
  String get monthJuly => 'Julio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Septiembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Diciembre';

  @override
  String get receiptDetail => 'Detalle del Comprobante';

  @override
  String get fileName => 'Nombre del archivo';

  @override
  String get uploadDate => 'Fecha de carga';

  @override
  String get availableActions => 'Acciones disponibles';

  @override
  String get shareFile => 'Compartir';

  @override
  String get openWith => 'Abrir con';

  @override
  String get renameFile => 'Renombrar';

  @override
  String get deleteFile => 'Eliminar';

  @override
  String get renameFileTitle => 'Renombrar archivo';

  @override
  String get newFileName => 'Nuevo nombre del archivo';

  @override
  String get fileNameHint => 'Ej: nuevo_nombre.pdf';

  @override
  String get confirmDeletion => 'Confirmar eliminación';

  @override
  String confirmDeleteFile(String fileName) {
    return '¿Estás seguro de que quieres eliminar \"$fileName\"?';
  }

  @override
  String get fileNameEmpty => 'El nombre del archivo no puede estar vacío.';

  @override
  String get fileRenamed => 'Archivo renombrado correctamente.';

  @override
  String get fileDeleted => 'Archivo eliminado correctamente';

  @override
  String errorRenaming(String error) {
    return 'Error al renombrar: $error';
  }

  @override
  String errorDeleting(String error) {
    return 'Error al eliminar: $error';
  }

  @override
  String errorSharing(String error) {
    return 'Error al compartir archivo: $error';
  }

  @override
  String errorOpening(String error) {
    return 'Error al abrir el archivo: $error';
  }

  @override
  String cannotOpenFile(String message) {
    return 'No se pudo abrir el archivo: $message';
  }

  @override
  String shareFileText(String fileName) {
    return 'Compartir archivo: $fileName';
  }

  @override
  String get exportMonth => 'Exportar mes';

  @override
  String get exportYear => 'Exportar año';

  @override
  String get exportOptions => 'Opciones de exportación';

  @override
  String get exportAsZip => 'Exportar como ZIP';

  @override
  String get exportAsPdf => 'Exportar como PDF resumen';

  @override
  String get exporting => 'Exportando...';

  @override
  String get exportSuccess => 'Exportación completada exitosamente';

  @override
  String exportError(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get noReceiptsToExport => 'No hay comprobantes para exportar';
}
