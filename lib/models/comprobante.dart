class Comprobante {
  final String nombre;
  final String fecha; // Ej: "Julio 2025"

  Comprobante({required this.nombre, required this.fecha});

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fecha': fecha,
    };
  }

  factory Comprobante.fromMap(Map<String, dynamic> map) {
    return Comprobante(
      nombre: map['nombre'],
      fecha: map['fecha'],
    );
  }
}
