import 'package:app_vet/model/cuenta_model.dart';
import 'package:app_vet/provider/provider.dart';
import 'package:flutter/material.dart';

class CuentaProvider extends ChangeNotifier {
  Future<List<Cuenta>> getCuentas(int perPage, int page) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps = await db.query('Cuenta',
        orderBy: 'id_cuenta DESC', limit: perPage * page);
    final List<Cuenta> cuentas = [];

    for (final map in maps) {
      final nombreTipoCuenta =
          await _getNombreTipoCuenta(map['id_tipo_cuenta']);
      final nombreMetodoPago =
          await _getNombreMetodoPago(map['id_metodo_pago']);

      cuentas.add(Cuenta(
        idCuenta: map['id_cuenta'],
        idTipoCuenta: map['id_tipo_cuenta'],
        precio: map['precio'],
        idMetodoPago: map['id_metodo_pago'],
        fecha: map['fecha'],
        nombreTipoCuenta: nombreTipoCuenta,
        nombreCliente: map['nombreCliente'],
        nombreMetodoPago: nombreMetodoPago,
      ));
    }
    return cuentas;
  }

  Future<List<Cuenta>> getAllCuentas() async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'Cuenta',
      orderBy: 'id_cuenta DESC',
    );
    final List<Cuenta> cuentas = [];

    for (final map in maps) {
      final nombreTipoCuenta =
          await _getNombreTipoCuenta(map['id_tipo_cuenta']);
      final nombreMetodoPago =
          await _getNombreMetodoPago(map['id_metodo_pago']);

      cuentas.add(Cuenta(
        idCuenta: map['id_cuenta'],
        idTipoCuenta: map['id_tipo_cuenta'],
        precio: map['precio'],
        idMetodoPago: map['id_metodo_pago'],
        fecha: map['fecha'],
        nombreTipoCuenta: nombreTipoCuenta,
        nombreCliente: map['nombreCliente'],
        nombreMetodoPago: nombreMetodoPago,
      ));
    }
    return cuentas;
  }

  Future<String?> _getNombreMetodoPago(int idMetodoPago) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'Metodo_pago',
      where: 'id_metodo_pago = ?',
      whereArgs: [idMetodoPago],
    );
    return result.isNotEmpty ? result.first['nombre_metodo_pago'] : null;
  }

  Future<String> _getNombreTipoCuenta(int idTipoCuenta) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'Tipo_cuenta',
      where: 'id_tipo_cuenta = ?',
      whereArgs: [idTipoCuenta],
    );
    return result.isNotEmpty
        ? result.first['nombre_tipo_cuenta']
        : 'Desconocido';
  }

  Future<void> deleteCuenta(int idCuenta) async {
    final db = await DatabaseProvider().initDB();
    await db.delete(
      'Cuenta',
      where: 'id_cuenta = ?',
      whereArgs: [idCuenta],
    );
    notifyListeners();
  }
}
