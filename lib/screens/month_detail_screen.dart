import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/comprobante.dart';
import '../services/comprobante_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

