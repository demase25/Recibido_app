import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../services/archivo_service.dart';
import '../services/comprobante_service.dart';
import '../services/shared_files_service.dart';
import '../models/comprobante.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> meses = const [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  int? mesInicio; // 0-based
  int? anioInicio;
  bool cargando = true;
  Map<String, int> comprobantesPorFecha = {};
  BannerAd? _bannerAd;
  bool _mostrarInstructivo = true; // Controla si mostrar la foto instructiva

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
    _processSharedFiles();
    _inicializarBanner();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _inicializarBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1255034608846557/5650144787', // ID real de banner
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }

  void _ocultarInstructivo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mostrarInstructivo', false);
    setState(() {
      _mostrarInstructivo = false;
    });
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mesInicio = prefs.getInt('mesInicio') ?? DateTime.now().month - 1;
      anioInicio = prefs.getInt('anioInicio') ?? DateTime.now().year;
      _mostrarInstructivo = prefs.getBool('mostrarInstructivo') ?? true;
    });
    await _cargarComprobantesPorFecha();
    setState(() { cargando = false; });
  }

  Future<void> _guardarPreferencias(int mes, int anio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mesInicio', mes);
    await prefs.setInt('anioInicio', anio);
    setState(() {
      mesInicio = mes;
      anioInicio = anio;
      cargando = true;
    });
    await _cargarComprobantesPorFecha();
    setState(() { cargando = false; });
  }



  // Método para mostrar confirmación de borrado
  void _mostrarConfirmacionBorrar(String fecha) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
                     title: Row(
             mainAxisSize: MainAxisSize.min,
             children: [
               Icon(Icons.warning, color: Colors.orange, size: 20),
               SizedBox(width: 8),
               Text(
                 'Confirmar borrado',
                 style: TextStyle(fontSize: 16),
               ),
             ],
           ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Estás seguro de que quieres borrar el mes completo?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Mes: $fecha',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Esta acción:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Borrará todos los comprobantes del mes'),
                      Text('• Eliminará todos los archivos asociados'),
                      Text('• No se puede deshacer'),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    '⚠️ Esta acción es irreversible',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _borrarMesCompleto(fecha);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('BORRAR'),
            ),
          ],
        );
      },
    );
  }

  // Método para borrar el mes completo
  Future<void> _borrarMesCompleto(String fecha) async {
    try {
      setState(() {
        cargando = true;
      });

      // Mostrar indicador de progreso
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Borrando mes...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Borrando $fecha...'),
              ],
            ),
          );
        },
      );

      // 1. Obtener todos los comprobantes del mes
      final comprobantes = await ComprobanteService.obtenerPorFecha(fecha);
      
      // 2. Borrar todos los archivos físicos
      for (final comprobante in comprobantes) {
        try {
          await ArchivoService.eliminarArchivo(comprobante.nombre, fecha);
        } catch (e) {
          print('Error al borrar archivo: $e');
        }
      }
      
             // 3. Borrar todos los comprobantes de la base de datos
       for (final comprobante in comprobantes) {
         await ComprobanteService.eliminarComprobante(comprobante.nombre, fecha);
       }
      
      // 4. Intentar eliminar la carpeta del mes si está vacía
      try {
        await ArchivoService.eliminarCarpeta(fecha);
      } catch (e) {
        print('Error al eliminar carpeta: $e');
      }

      // Cerrar el diálogo de progreso
      Navigator.pop(context);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Mes $fecha borrado completamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Recargar la lista de comprobantes
      await _cargarComprobantesPorFecha();
      
      setState(() {
        cargando = false;
      });

    } catch (e) {
      // Cerrar el diálogo de progreso si hay error
      Navigator.pop(context);
      
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al borrar el mes: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      
      setState(() {
        cargando = false;
      });
    }
  }

  Future<void> _cargarComprobantesPorFecha() async {
    comprobantesPorFecha.clear();
    final List<Future<void>> futures = [];
    
    // Mostrar 12 meses desde la fecha de inicio
    for (int i = 0; i < 12; i++) {
      int mes = (mesInicio! + i) % 12;
      int anio = anioInicio! + ((mesInicio! + i) ~/ 12);
      String fecha = "${meses[mes]} $anio";
      futures.add(ComprobanteService.obtenerPorFecha(fecha).then((lista) {
        comprobantesPorFecha[fecha] = lista.length;
      }));
    }
    
    await Future.wait(futures);
  }

  Future<void> _processSharedFiles() async {
    await SharedFilesService.processSharedFiles();
  }

  void _mostrarSelectorMesAnio() async {
    int mesSeleccionado = mesInicio ?? DateTime.now().month - 1;
    int anioSeleccionado = anioInicio ?? DateTime.now().year;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecciona mes y año de inicio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: mesSeleccionado,
                isExpanded: true,
                items: List.generate(12, (i) => DropdownMenuItem(
                  value: i,
                  child: Text(meses[i]),
                )),
                onChanged: (v) {
                  if (v != null) {
                    setState(() { mesSeleccionado = v; });
                  }
                },
              ),
              SizedBox(height: 16),
              DropdownButton<int>(
                value: anioSeleccionado,
                isExpanded: true,
                items: List.generate(10, (i) => DropdownMenuItem(
                  value: DateTime.now().year - 5 + i,
                  child: Text("${DateTime.now().year - 5 + i}"),
                )),
                onChanged: (v) {
                  if (v != null) {
                    setState(() { anioSeleccionado = v; });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _guardarPreferencias(mesSeleccionado, anioSeleccionado);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando || mesInicio == null || anioInicio == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Recibido!')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
                 actions: [
           IconButton(
             icon: Icon(Icons.settings, color: Colors.amberAccent),
             tooltip: 'Elegir mes/año de inicio',
             onPressed: _mostrarSelectorMesAnio,
           ),
         ],
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                                 child: ListView.builder(
                   itemCount: 12,
                   itemBuilder: (context, index) {
                     int mes = (mesInicio! + index) % 12;
                     int anio = anioInicio! + ((mesInicio! + index) ~/ 12);
                     String fecha = "${meses[mes]} $anio";
                     int cantidad = comprobantesPorFecha[fecha] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.teal.shade100,
                                                 child: ListTile(
                           title: Text(
                             '$fecha',
                             style: const TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           subtitle: Text('Comprobantes: $cantidad'),
                                                       trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botón de eliminar con mejor espaciado
                                Container(
                                  margin: EdgeInsets.only(right: 16),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade400,
                                      size: 22,
                                    ),
                                    onPressed: () => _mostrarConfirmacionBorrar(fecha),
                                    tooltip: 'Borrar mes completo',
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.red.shade50,
                                      padding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                                // Flecha de navegación más separada
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.teal.shade600,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                           onTap: () {
                             Navigator.pushNamed(
                               context,
                               '/monthDetail',
                               arguments: {'mes': meses[mes], 'anio': anio},
                             );
                           },
                         ),
                      ),
                    );
                  },
                ),
              ),
              if (_bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
          // Overlay de la foto instructiva
          if (_mostrarInstructivo)
            GestureDetector(
              onTap: _ocultarInstructivo,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/instructivorecibido.png',
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 0.95,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'Toca la pantalla para continuar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
            await _cargarComprobantesPorFecha();
            setState(() {});
          }
        },
      ),
    );
  }
}
