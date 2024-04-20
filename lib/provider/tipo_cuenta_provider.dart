import 'package:app_vet/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_vet/model/tipo_cuenta_model.dart';

class TipoCuentaProvider extends ChangeNotifier {
  Future<void> insertTipoCuenta(TipoCuenta tipoCuenta) async {
    final db = await DatabaseProvider().initDB();
    await db.insert('Tipo_cuenta', tipoCuenta.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<List<TipoCuenta>> getTiposCuenta() async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps = await db.query('Tipo_cuenta');
    return List.generate(maps.length, (i) {
      return TipoCuenta(
        idTipoCuenta: maps[i]['id_tipo_cuenta'],
        nombreTipoCuenta: maps[i]['nombre_tipo_cuenta'],
      );
    });
  }
}
