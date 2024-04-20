import 'package:app_vet/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:app_vet/model/ficha_model.dart';

class FichaProvider extends ChangeNotifier {
  Future<List<Ficha>> getFichas(int perpage, int page) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps = await db.query('Ficha',
        orderBy: 'id_ficha DESC', limit: perpage * page);
    List<Ficha> fichas = [];
    for (final map in maps) {
      final nombrePaciente = await _getNombrePaciente(map['id_paciente']);
      final nombreTutor = await _getNombreTutor(map['id_tutor']);

      fichas.add(Ficha(
          idFicha: map['id_ficha'],
          idPaciente: map['id_paciente'],
          idTutor: map['id_tutor'],
          fecha: map['fecha'],
          nombrePaciente: nombrePaciente,
          nombreTutor: nombreTutor));
    }
    return fichas;
  }

  Future<List<Ficha>> getAllFichas() async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> maps =
        await db.query('Ficha', orderBy: 'id_ficha DESC');
    List<Ficha> fichas = [];
    for (final map in maps) {
      final nombrePaciente = await _getNombrePaciente(map['id_paciente']);
      final nombreTutor = await _getNombreTutor(map['id_tutor']);

      fichas.add(Ficha(
          idFicha: map['id_ficha'],
          idPaciente: map['id_paciente'],
          idTutor: map['id_tutor'],
          fecha: map['fecha'],
          nombrePaciente: nombrePaciente,
          nombreTutor: nombreTutor));
    }
    return fichas;
  }

  Future<String?> _getNombrePaciente(int idPaciente) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'Paciente',
      where: 'id_paciente = ?',
      whereArgs: [idPaciente],
    );
    return result.isNotEmpty ? result.first['nombre_paciente'] : null;
  }

  Future<String?> _getNombreTutor(int idTutor) async {
    final db = await DatabaseProvider().initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'Tutor',
      where: 'id_tutor = ?',
      whereArgs: [idTutor],
    );
    return result.isNotEmpty ? result.first['nombre_tutor'] : null;
  }
}
