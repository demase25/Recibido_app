import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/comprobante.dart';
import '../services/archivo_service.dart';

class ComprobanteService {
  static const String key = 'comprobantes';

  // Guardar un nuevo comprobante
  static Future<void> guardarComprobante(Comprobante nuevo) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    data.add(jsonEncode(nuevo.toMap()));

    await prefs.setStringList(key, data);
  }

  // Cargar todos los comprobantes guardados
  static Future<List<Comprobante>> cargarComprobantes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    return data
        .map((jsonStr) => Comprobante.fromMap(jsonDecode(jsonStr)))
        .toList();
  }

  // Filtrar comprobantes por mes
  static Future<List<Comprobante>> obtenerPorFecha(String fecha) async {
    final todos = await cargarComprobantes();
    return todos.where((c) => c.fecha == fecha).toList();
  }

  // Eliminar un comprobante específico
  static Future<void> eliminarComprobante(String nombre, String fecha) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    // Filtrar el comprobante a eliminar
    final dataFiltrada = data.where((jsonStr) {
      final comprobante = Comprobante.fromMap(jsonDecode(jsonStr));
      return !(comprobante.nombre == nombre && comprobante.fecha == fecha);
    }).toList();

    await prefs.setStringList(key, dataFiltrada);
  }

  // Renombrar un comprobante
  static Future<void> renombrarComprobante(String nombreActual, String nuevoNombre, String fecha) async {
    // Primero renombrar el archivo físico
    await ArchivoService.renombrarArchivo(nombreActual, nuevoNombre, fecha);
    
    // Luego actualizar la base de datos
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];

    // Buscar y actualizar el comprobante
    final dataActualizada = data.map((jsonStr) {
      final comprobante = Comprobante.fromMap(jsonDecode(jsonStr));
      if (comprobante.nombre == nombreActual && comprobante.fecha == fecha) {
        // Crear nuevo comprobante con el nombre actualizado
        return jsonEncode(Comprobante(
          nombre: nuevoNombre,
          fecha: fecha,
        ).toMap());
      }
      return jsonStr;
    }).toList();

    await prefs.setStringList(key, dataActualizada);
  }
}
