import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../models/comprobante.dart';
import '../services/comprobante_service.dart';
import '../services/archivo_service.dart';

class ComprobanteDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final String nombre = args['nombre'];
    final String mes = args['mes'];
    final int anio = args['anio'];
    final String fecha = '$mes $anio';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Comprobante'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.teal.shade400,
                Colors.teal.shade600,
                Colors.teal.shade800,
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del archivo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        nombre.toLowerCase().endsWith('.pdf') 
                            ? Icons.picture_as_pdf 
                            : Icons.image,
                        size: 32,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Nombre del archivo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    nombre,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Fecha de carga',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    fecha,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Título de acciones
            Text(
              'Acciones disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Acciones
            Expanded(
              child: Column(
                children: [
                  // Botón Compartir
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.share, color: Colors.white),
                      label: Text(
                        'Compartir',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        try {
                          final ruta = await ArchivoService.obtenerRutaArchivo(nombre, fecha);
                          await Share.shareXFiles(
                            [XFile(ruta)],
                            text: 'Compartir archivo: $nombre',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al compartir archivo: $e')),
                          );
                        }
                      },
                    ),
                  ),
                  
                  // Botón Abrir con
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.open_in_new, color: Colors.white),
                      label: Text(
                        'Abrir con',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        try {
                          final ruta = await ArchivoService.obtenerRutaArchivo(nombre, fecha);
                          final result = await OpenFile.open(ruta);
                          if (result.type != ResultType.done) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No se pudo abrir el archivo: ${result.message}')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al abrir el archivo: $e')),
                          );
                        }
                      },
                    ),
                  ),
                  
                  // Botón Renombrar
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        'Renombrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade300,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        _mostrarDialogoRenombrar(context, nombre, fecha);
                      },
                    ),
                  ),
                  
                  // Botón Eliminar
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 12),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text(
                        'Eliminar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade300,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        _mostrarDialogoEliminar(context, nombre, fecha);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoRenombrar(BuildContext context, String nombreActual, String fecha) {
    final TextEditingController _nuevoNombreController = TextEditingController();
    _nuevoNombreController.text = nombreActual;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Renombrar archivo'),
          content: TextField(
            controller: _nuevoNombreController,
            decoration: InputDecoration(
              labelText: 'Nuevo nombre del archivo',
              hintText: 'Ej: nuevo_nombre.pdf',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nuevoNombre = _nuevoNombreController.text;
                if (nuevoNombre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El nombre del archivo no puede estar vacío.')),
                  );
                  return;
                }

                Navigator.of(context).pop();
                try {
                  await ComprobanteService.renombrarComprobante(nombreActual, nuevoNombre, fecha);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Archivo renombrado correctamente.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al renombrar: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Renombrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEliminar(BuildContext context, String nombre, String fecha) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar "$nombre"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ComprobanteService.eliminarComprobante(nombre, fecha);
                  Navigator.of(context).pop(); // Volver a la pantalla anterior
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Archivo eliminado correctamente')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

