class Paciente {
  int? idPaciente;
  String? nombrePaciente;
  String? raza;
  String? especie;
  String? edad;
  String? sexo;

  Paciente(
      {this.idPaciente,
      this.nombrePaciente,
      this.raza,
      this.especie,
      this.edad,
      this.sexo});

  Map<String, dynamic> toMap() {
    return {
      'id_paciente': idPaciente,
      'nombre_paciente': nombrePaciente,
      'raza': raza,
      'especie': especie,
      'edad': edad,
      'sexo': sexo,
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
        idPaciente: map['id_paciente'],
        nombrePaciente: map['nombre_paciente'],
        edad: map['edad'],
        raza: map['raza'],
        especie: map['especie'],
        sexo: map['sexo']);
  }
}
