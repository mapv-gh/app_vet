class MetodoPago {
  int? idMetodoPago;
  String? nombreMetodoPago;

  MetodoPago({this.idMetodoPago, this.nombreMetodoPago});

  Map<String, dynamic> toMap() {
    return {
      'id_metodo_pago': idMetodoPago,
      'nombre_metodo_pago': nombreMetodoPago,
    };
  }
}
