import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;
import '../models/comprobante.dart';
import '../services/archivo_service.dart';

class ExportService {
  // Exportar comprobantes del mes como ZIP
  static Future<void> exportarMesComoZip(List<Comprobante> comprobantes, String mes, int anio) async {
    try {
      final archivo = Archive();
      
      for (final comprobante in comprobantes) {
        try {
          final rutaArchivo = await ArchivoService.obtenerRutaArchivo(
            comprobante.nombre, 
            '$mes $anio'
          );
          final archivoFile = File(rutaArchivo);
          final bytes = await archivoFile.readAsBytes();
          
          archivo.addFile(ArchiveFile(
            comprobante.nombre,
            bytes.length,
            bytes,
          ));
        } catch (e) {
          print('Error al agregar archivo ${comprobante.nombre}: $e');
        }
      }
      
      // Crear el archivo ZIP
      final zipBytes = ZipEncoder().encode(archivo);
      final tempDir = await getTemporaryDirectory();
      final zipFile = File(p.join(tempDir.path, 'comprobantes_$mes$anio.zip'));
      await zipFile.writeAsBytes(zipBytes!);
      
      // Compartir el archivo ZIP
      await Share.shareXFiles([XFile(zipFile.path)], 
        text: 'Comprobantes de $mes $anio');
        
    } catch (e) {
      throw Exception('Error al exportar ZIP: $e');
    }
  }
  
  // Exportar comprobantes del mes como PDF resumen
  static Future<void> exportarMesComoPdf(List<Comprobante> comprobantes, String mes, int anio) async {
    try {
      final pdf = pw.Document();
      
      // Crear página de portada
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Resumen de Comprobantes',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Período: $mes $anio',
                  style: pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total de comprobantes: ${comprobantes.length}',
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Lista de comprobantes:',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                ...comprobantes.map((c) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text('• ${c.nombre}'),
                )).toList(),
              ],
            );
          },
        ),
      );
      
      // Crear páginas con miniaturas de los comprobantes
      for (int i = 0; i < comprobantes.length; i += 4) {
        final comprobantesPagina = comprobantes.skip(i).take(4).toList();
        
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Comprobantes - Página ${(i ~/ 4) + 1}',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 20),
                  ...comprobantesPagina.map((comprobante) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          comprobante.nombre,
                          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Container(
                          width: 200,
                          height: 150,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.grey),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'Miniatura del comprobante',
                              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              );
            },
          ),
        );
      }
      
      // Guardar el PDF
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File(p.join(tempDir.path, 'resumen_comprobantes_$mes$anio.pdf'));
      await pdfFile.writeAsBytes(await pdf.save());
      
      // Compartir el archivo PDF
      await Share.shareXFiles([XFile(pdfFile.path)], 
        text: 'Resumen de comprobantes de $mes $anio');
        
    } catch (e) {
      throw Exception('Error al exportar PDF: $e');
    }
  }
  
  // Exportar comprobantes del año como ZIP
  static Future<void> exportarAnioComoZip(List<Comprobante> comprobantes, int anio) async {
    try {
      final archivo = Archive();
      
      for (final comprobante in comprobantes) {
        try {
          final rutaArchivo = await ArchivoService.obtenerRutaArchivo(
            comprobante.nombre, 
            comprobante.fecha
          );
          final archivoFile = File(rutaArchivo);
          final bytes = await archivoFile.readAsBytes();
          
          // Organizar por carpetas de mes
          final nombreArchivo = '${comprobante.fecha}/${comprobante.nombre}';
          archivo.addFile(ArchiveFile(
            nombreArchivo,
            bytes.length,
            bytes,
          ));
        } catch (e) {
          print('Error al agregar archivo ${comprobante.nombre}: $e');
        }
      }
      
      // Crear el archivo ZIP
      final zipBytes = ZipEncoder().encode(archivo);
      final tempDir = await getTemporaryDirectory();
      final zipFile = File(p.join(tempDir.path, 'comprobantes_$anio.zip'));
      await zipFile.writeAsBytes(zipBytes!);
      
      // Compartir el archivo ZIP
      await Share.shareXFiles([XFile(zipFile.path)], 
        text: 'Comprobantes del año $anio');
        
    } catch (e) {
      throw Exception('Error al exportar ZIP del año: $e');
    }
  }
  
  // Exportar comprobantes del año como PDF resumen
  static Future<void> exportarAnioComoPdf(List<Comprobante> comprobantes, int anio) async {
    try {
      final pdf = pw.Document();
      
      // Agrupar comprobantes por mes
      final comprobantesPorMes = <String, List<Comprobante>>{};
      for (final comprobante in comprobantes) {
        comprobantesPorMes.putIfAbsent(comprobante.fecha, () => []).add(comprobante);
      }
      
      // Crear página de portada
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Resumen Anual de Comprobantes',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Año: $anio',
                  style: pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total de comprobantes: ${comprobantes.length}',
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Resumen por mes:',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                ...comprobantesPorMes.entries.map((entry) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Text('${entry.key}: ${entry.value.length} comprobantes'),
                )).toList(),
              ],
            );
          },
        ),
      );
      
      // Crear páginas por mes
      for (final entry in comprobantesPorMes.entries) {
        final mes = entry.key;
        final comprobantesMes = entry.value;
        
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    mes,
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Comprobantes (${comprobantesMes.length}):',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  ...comprobantesMes.map((c) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Text('• ${c.nombre}'),
                  )).toList(),
                ],
              );
            },
          ),
        );
      }
      
      // Guardar el PDF
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File(p.join(tempDir.path, 'resumen_anual_$anio.pdf'));
      await pdfFile.writeAsBytes(await pdf.save());
      
      // Compartir el archivo PDF
      await Share.shareXFiles([XFile(pdfFile.path)], 
        text: 'Resumen anual de comprobantes $anio');
        
    } catch (e) {
      throw Exception('Error al exportar PDF del año: $e');
    }
  }
}
