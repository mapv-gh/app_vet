class TipoCuenta {
  int? idTipoCuenta;
  String? nombreTipoCuenta;

  TipoCuenta({this.idTipoCuenta, this.nombreTipoCuenta});

  Map<String, dynamic> toMap() {
    return {
      'id_tipo_cuenta': idTipoCuenta,
      'nombre_tipo_cuenta': nombreTipoCuenta,
    };
  }
}
