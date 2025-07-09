import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../services/archivo_service.dart';
import '../services/comprobante_service.dart';
import '../services/shared_files_service.dart';
import '../models/comprobante.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> meses = const [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  void initState() {
    super.initState();
    _processSharedFiles();
  }

  Future<void> _processSharedFiles() async {
    await SharedFilesService.processSharedFiles();
  }

  @override
  Widget build(BuildContext context) {
    final int anioActual = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recibido!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
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
      body: ListView.builder(
        itemCount: meses.length,
        itemBuilder: (context, index) {
          String mes = meses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.teal.shade100,
              child: ListTile(
                title: Text(
                  '$mes $anioActual',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/monthDetail',
                    arguments: {'mes': mes, 'anio': anioActual},
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final resultado = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'jpg', 'png'],
          );

          if (resultado != null && resultado.files.isNotEmpty) {
            final archivo = File(resultado.files.single.path!);
            final nombre = resultado.files.single.name;

            final mesActual = meses[DateTime.now().month - 1];
            final anioActual = DateTime.now().year;
            final fecha = '$mesActual $anioActual'; // Ej: Julio 2025

            final ruta = await ArchivoService.guardarArchivo(archivo, nombre, fecha);

            final comprobante = Comprobante(
              nombre: nombre,
              fecha: fecha,
            );

            await ComprobanteService.guardarComprobante(comprobante);

            // Mostrar mensaje
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Archivo guardado con éxito!')),
            );
          }
        },
      ),
    );
  }
}
