class Tutor {
  int? idTutor;
  String? nombreTutor;
  String? celular;
  String? direccion;
  String? rut;

  Tutor(
      {this.idTutor, this.nombreTutor, this.celular, this.direccion, this.rut});

  Map<String, dynamic> toMap() {
    return {
      'id_tutor': idTutor,
      'nombre_tutor': nombreTutor,
      'celular': celular,
      'direccion': direccion,
      'rut': rut,
    };
  }

  factory Tutor.fromMap(Map<String, dynamic> map) {
    return Tutor(
        idTutor: map['id_tutor'],
        nombreTutor: map['nombre_tutor'],
        direccion: map['direccion'],
        celular: map['celular'],
        rut: map['rut']);
  }
}
