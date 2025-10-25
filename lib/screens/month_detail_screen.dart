import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/comprobante.dart';
import '../services/comprobante_service.dart';
import '../services/export_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';

class MonthDetailScreen extends StatefulWidget {
  @override
  _MonthDetailScreenState createState() => _MonthDetailScreenState();
}

class _MonthDetailScreenState extends State<MonthDetailScreen> {
  List<Comprobante> comprobantes = [];
  late String mes;
  late int anio;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _inicializarBanner();
    _inicializarIntersticial();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _inicializarBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1255034608846557/9354968965', // Segundo banner
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }

  void _inicializarIntersticial() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-1255034608846557/6728805623', // ID del intersticial
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _interstitialAd = null;
              // Navegar hacia atrás después de mostrar el anuncio
              Navigator.pop(context);
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              ad.dispose();
              _interstitialAd = null;
              // Si falla el anuncio, navegar hacia atrás directamente
              Navigator.pop(context);
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Intersticial falló al cargar: $error');
        },
      ),
    );
  }

  void _mostrarIntersticialYVolver() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      // Si no hay intersticial disponible, volver directamente
      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    mes = args['mes'];
    anio = args['anio'];
    _cargarComprobantes();
  }

  Future<void> _cargarComprobantes() async {
    final lista = await ComprobanteService.obtenerPorFecha('$mes $anio');
    setState(() {
      comprobantes = lista;
    });
  }

  void _mostrarOpcionesExportacion() {
    if (comprobantes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noReceiptsToExport)),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.exportOptions),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.archive),
                title: Text(AppLocalizations.of(context)!.exportAsZip),
                subtitle: Text('Todos los comprobantes en un archivo ZIP'),
                onTap: () {
                  Navigator.pop(context);
                  _exportarComoZip();
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text(AppLocalizations.of(context)!.exportAsPdf),
                subtitle: Text('PDF resumen con miniaturas'),
                onTap: () {
                  Navigator.pop(context);
                  _exportarComoPdf();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportarComoZip() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(AppLocalizations.of(context)!.exporting),
              ],
            ),
          );
        },
      );

      await ExportService.exportarMesComoZip(comprobantes, mes, anio);
      
      Navigator.pop(context); // Cerrar diálogo de carga
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.exportSuccess)),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar diálogo de carga
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.exportError(e.toString()))),
      );
    }
  }

  Future<void> _exportarComoPdf() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(AppLocalizations.of(context)!.exporting),
              ],
            ),
          );
        },
      );

      await ExportService.exportarMesComoPdf(comprobantes, mes, anio);
      
      Navigator.pop(context); // Cerrar diálogo de carga
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.exportSuccess)),
      );
    } catch (e) {
      Navigator.pop(context); // Cerrar diálogo de carga
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.exportError(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _mostrarIntersticialYVolver();
        return false; // No permitir navegación directa
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comprobantes de $mes $anio'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _mostrarIntersticialYVolver,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: _mostrarOpcionesExportacion,
              tooltip: AppLocalizations.of(context)!.exportMonth,
            ),
          ],
        ),
      body: Column(
        children: [
          Expanded(
            child: comprobantes.isEmpty
                ? const Center(child: Text('Sin comprobantes aún.'))
                : ListView.builder(
                    itemCount: comprobantes.length,
                    itemBuilder: (context, index) {
                      final c = comprobantes[index];
                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: ListTile(
                          title: Text(c.nombre),
                          onTap: () async {
                            final resultado = await Navigator.pushNamed(
                              context,
                              '/comprobanteDetail',
                              arguments: {
                                'nombre': c.nombre,
                                'mes': mes,
                                'anio': anio,
                              },
                            );
                            if (resultado == true) {
                              _cargarComprobantes();
                            }
                          },
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
      ),
    );
  }
}

