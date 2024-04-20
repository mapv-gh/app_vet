import 'package:app_vet/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:app_vet/model/tutor_model.dart'; // Asegúrate de importar el modelo Tutor

class TutorProvider extends ChangeNotifier {
  Future<List<Tutor>> getTutors(int perpage, int page) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps = await db.query('Tutor',
        orderBy: 'id_tutor DESC', limit: perpage * page);
    return List.generate(maps.length, (i) {
      return Tutor(
        idTutor: maps[i]['id_tutor'],
        nombreTutor: maps[i]['nombre_tutor'],
        celular: maps[i]['celular'],
        direccion: maps[i]['direccion'],
        rut: maps[i]['rut'],
      );
    });
  }

  Future<List<Tutor>> getAllTutors() async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps =
        await db.query('Tutor', orderBy: 'id_tutor DESC');
    return List.generate(maps.length, (i) {
      return Tutor(
        idTutor: maps[i]['id_tutor'],
        nombreTutor: maps[i]['nombre_tutor'],
        celular: maps[i]['celular'],
        direccion: maps[i]['direccion'],
        rut: maps[i]['rut'],
      );
    });
  }

  Future<Tutor> getTutorById(int idTutor) async {
    final db = await DatabaseProvider().initDB();
    List<Map<String, dynamic>> maps = await db.query(
      'Tutor',
      where: 'id_tutor = ?',
      whereArgs: [idTutor],
    );
    if (maps.isNotEmpty) {
      return Tutor.fromMap(maps.first);
    } else {
      throw Exception('No se encontró ningún tutor con el ID proporcionado');
    }
  }

  Future<void> updateTutor(Tutor tutor) async {
    final db = await DatabaseProvider().initDB();
    await db.update(
      'Tutor',
      tutor.toMap(),
      where: 'id_tutor = ?',
      whereArgs: [tutor.idTutor],
    );
    notifyListeners();
  }
}
