import 'dart:io';
import 'package:flutter/services.dart';
import 'archivo_service.dart';
import 'comprobante_service.dart';
import '../models/comprobante.dart';

class SharedFilesService {
  static const MethodChannel _channel = MethodChannel('com.example.recibido_app/shared_files');

  static Future<List<String>?> getSharedFiles() async {
    try {
      final List<dynamic>? files = await _channel.invokeMethod('getSharedFiles');
      return files?.cast<String>();
    } on PlatformException catch (e) {
      print('Error getting shared files: $e');
      return null;
    }
  }

  static Future<void> processSharedFiles() async {
    final sharedFiles = await getSharedFiles();
    
    if (sharedFiles != null && sharedFiles.isNotEmpty) {
      for (String filePath in sharedFiles) {
        await _processSharedFile(filePath);
      }
    }
  }

  static Future<void> _processSharedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('Shared file does not exist: $filePath');
        return;
      }

      final fileName = file.path.split('/').last;
      final mesActual = _getMesActual();
      final anioActual = DateTime.now().year;
      final fecha = '$mesActual $anioActual';

      // Guardar el archivo en la carpeta del mes
      final rutaGuardada = await ArchivoService.guardarArchivo(file, fileName, fecha);

      // Crear y guardar el comprobante
      final comprobante = Comprobante(
        nombre: fileName,
        fecha: fecha,
      );

      await ComprobanteService.guardarComprobante(comprobante);

      print('Archivo compartido guardado exitosamente: $fileName en $fecha');
    } catch (e) {
      print('Error processing shared file: $e');
    }
  }

  static String _getMesActual() {
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[DateTime.now().month - 1];
  }
} 