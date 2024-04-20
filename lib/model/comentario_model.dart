class Comentario {
  int? idComentario;
  String? comentario;
  int? idFicha;
  String? fecha;
  String tipoComentario;

  Comentario(
      {this.idComentario,
      this.comentario,
      this.idFicha,
      this.fecha,
      required this.tipoComentario});

  Map<String, dynamic> toMap() {
    return {
      'id_comentario': idComentario,
      'comentario': comentario,
      'id_ficha': idFicha,
      'fecha': fecha,
      'tipoComentario': tipoComentario
    };
  }
}
