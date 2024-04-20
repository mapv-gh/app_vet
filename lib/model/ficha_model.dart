class Ficha {
  int? idFicha;
  int? idPaciente;
  int? idTutor;
  String? fecha;
  String? nombrePaciente;
  String? nombreTutor;

  Ficha(
      {this.idFicha,
      this.idPaciente,
      this.idTutor,
      this.fecha,
      this.nombrePaciente,
      this.nombreTutor});

  Map<String, dynamic> toMap() {
    return {
      'id_ficha': idFicha,
      'id_paciente': idPaciente,
      'id_tutor': idTutor,
      'fecha': fecha,
      'nombrePaciente': nombrePaciente,
      'nombreTutor': nombreTutor
    };
  }
}
