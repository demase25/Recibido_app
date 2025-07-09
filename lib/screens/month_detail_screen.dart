import 'package:flutter/material.dart';
import '../models/comprobante.dart';
import '../services/comprobante_service.dart';

class MonthDetailScreen extends StatefulWidget {
  @override
  _MonthDetailScreenState createState() => _MonthDetailScreenState();
}

class _MonthDetailScreenState extends State<MonthDetailScreen> {
  List<Comprobante> comprobantes = [];
  late String mes;
  late int anio;

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
      body: comprobantes.isEmpty
          ? const Center(child: Text('Sin comprobantes aún.'))
          : ListView.builder(
              itemCount: comprobantes.length,
              itemBuilder: (context, index) {
                final c = comprobantes[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(c.nombre),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/comprobanteDetail',
                        arguments: {
                          'nombre': c.nombre,
                          'mes': mes,
                          'anio': anio,
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

