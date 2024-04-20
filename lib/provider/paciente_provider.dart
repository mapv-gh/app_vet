import 'package:app_vet/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:app_vet/model/paciente_model.dart';

class PacienteProvider extends ChangeNotifier {
  Future<Paciente> getPacienteById(int idPaciente) async {
    final db = await DatabaseProvider().initDB();
    List<Map<String, dynamic>> maps = await db.query(
      'Paciente',
      where: 'id_paciente = ?',
      whereArgs: [idPaciente],
    );
    if (maps.isNotEmpty) {
      return Paciente.fromMap(maps.first);
    } else {
      throw Exception('No se encontró ningún paciente con el ID proporcionado');
    }
  }
}
