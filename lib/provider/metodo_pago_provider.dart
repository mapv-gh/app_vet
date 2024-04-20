import 'package:app_vet/model/metodo_pago.dart';
import 'package:app_vet/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MetodoPagoProvider extends ChangeNotifier {
  Future<void> insertMetodoPago(MetodoPago metodoPago) async {
    final db = await DatabaseProvider().initDB();
    await db.insert('Metodo_pago', metodoPago.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<List<MetodoPago>> getMetodosPago() async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps = await db.query('Metodo_pago');
    return List.generate(maps.length, (i) {
      return MetodoPago(
        idMetodoPago: maps[i]['id_metodo_pago'],
        nombreMetodoPago: maps[i]['nombre_metodo_pago'],
      );
    });
  }
}
