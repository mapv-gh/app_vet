import 'package:app_vet/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_vet/model/comentario_model.dart';

class ComentarioProvider extends ChangeNotifier {
  Future<void> insertComentario(Comentario comentario) async {
    final db = await DatabaseProvider().initDB();
    await db.insert('Comentario', comentario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  Future<List<Comentario>> getComentarios(int idFicha) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'Comentario',
      where: 'id_ficha = ?',
      whereArgs: [idFicha],
    );
    return List.generate(maps.length, (i) {
      return Comentario(
          idComentario: maps[i]['id_comentario'],
          comentario: maps[i]['comentario'],
          idFicha: maps[i]['id_ficha'],
          fecha: maps[i]['fecha'],
          tipoComentario: maps[i]['tipo_comentario']);
    });
  }

  Future<void> eliminarComentario(int idComentario) async {
    final db = await DatabaseProvider().initDB();
    await db.delete(
      'Comentario',
      where: 'id_comentario = ?',
      whereArgs: [idComentario],
    );
  }
}
