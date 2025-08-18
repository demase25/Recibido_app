import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _inicializarBanner();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _inicializarBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1255034608846557/9984851900', // Segundo banner
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprobantes de $mes $anio'),
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
    );
  }
}

