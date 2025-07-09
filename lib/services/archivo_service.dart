import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ArchivoService {
  // Obtener carpeta de almacenamiento local
  static Future<Directory> obtenerDirectorioApp() async {
    return await getApplicationDocumentsDirectory();
  }

  // Guardar un archivo compartido en una carpeta específica
  static Future<String> guardarArchivo(File archivoOriginal, String nombreArchivo, String subcarpeta) async {
    final appDir = await obtenerDirectorioApp();
    final carpetaDestino = Directory(p.join(appDir.path, subcarpeta));

    if (!await carpetaDestino.exists()) {
      await carpetaDestino.create(recursive: true);
    }

    final destinoPath = p.join(carpetaDestino.path, nombreArchivo);
    final nuevoArchivo = await archivoOriginal.copy(destinoPath);

    return nuevoArchivo.path;
  }

  // Obtener la ruta de un archivo guardado
  static Future<String> obtenerRutaArchivo(String nombreArchivo, String subcarpeta) async {
    final appDir = await obtenerDirectorioApp();
    final rutaArchivo = p.join(appDir.path, subcarpeta, nombreArchivo);
    
    final archivo = File(rutaArchivo);
    if (await archivo.exists()) {
      return rutaArchivo;
    } else {
      throw Exception('Archivo no encontrado: $nombreArchivo');
    }
  }

  // Renombrar un archivo guardado
  static Future<void> renombrarArchivo(String nombreActual, String nuevoNombre, String subcarpeta) async {
    final appDir = await obtenerDirectorioApp();
    final rutaActual = p.join(appDir.path, subcarpeta, nombreActual);
    final rutaNueva = p.join(appDir.path, subcarpeta, nuevoNombre);
    
    final archivoActual = File(rutaActual);
    if (!await archivoActual.exists()) {
      throw Exception('Archivo no encontrado: $nombreActual');
    }
    
    // Verificar si el nuevo nombre ya existe
    final archivoNuevo = File(rutaNueva);
    if (await archivoNuevo.exists()) {
      throw Exception('Ya existe un archivo con el nombre: $nuevoNombre');
    }
    
    // Renombrar el archivo
    await archivoActual.rename(rutaNueva);
  }
}
