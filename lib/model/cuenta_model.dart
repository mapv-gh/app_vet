class Cuenta {
  int? idCuenta;
  int? idTipoCuenta;
  int? precio;
  int idMetodoPago;
  String fecha;
  String? nombreTipoCuenta;
  String nombreCliente;
  String? nombreMetodoPago;

  Cuenta(
      {this.idCuenta,
      this.idTipoCuenta,
      this.precio,
      required this.idMetodoPago,
      required this.fecha,
      this.nombreTipoCuenta,
      required this.nombreCliente,
      required this.nombreMetodoPago});

  Map<String, dynamic> toMap() {
    return {
      'id_cuenta': idCuenta,
      'id_tipo_cuenta': idTipoCuenta,
      'precio': precio,
      'id_metodo_pago': idMetodoPago,
      'fecha': fecha,
      'nombreTipoCuenta': nombreTipoCuenta,
      'nombreMetodoPago': nombreMetodoPago,
      'nombreCliente': nombreCliente
    };
  }
}
