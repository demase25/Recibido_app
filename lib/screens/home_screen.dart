import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1255034608846557/8312677581', // ID real de banner
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _ocultarInstructivo() {
    setState(() {
      _mostrarInstructivo = false;
    });
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mesInicio = prefs.getInt('mesInicio') ?? DateTime.now().month - 1;
      anioInicio = prefs.getInt('anioInicio') ?? DateTime.now().year;
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

  Future<void> _cargarComprobantesPorFecha() async {
    comprobantesPorFecha.clear();
    final List<Future<void>> futures = [];
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
                          trailing: const Icon(Icons.arrow_forward_ios),
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
