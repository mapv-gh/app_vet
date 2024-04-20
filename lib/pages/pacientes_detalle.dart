import 'package:app_vet/components/titutlo_detalle.dart';
import 'package:app_vet/model/comentario_model.dart';
import 'package:app_vet/model/ficha_model.dart';
import 'package:app_vet/model/paciente_model.dart';
import 'package:app_vet/model/tutor_model.dart';
import 'package:app_vet/pages/add_comentario.dart';
import 'package:app_vet/provider/comentario_provider.dart';
import 'package:app_vet/provider/paciente_provider.dart';
import 'package:app_vet/provider/tutor_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetallePaciente extends StatefulWidget {
  final Ficha ficha;
  const DetallePaciente({super.key, required this.ficha});

  @override
  State<DetallePaciente> createState() => _DetallePacienteState();
}

class _DetallePacienteState extends State<DetallePaciente> {
  late Future<Paciente> _paciente;
  late Future<Tutor> _tutor;

  @override
  void initState() {
    super.initState();
    _paciente = _getPaciente();
    _tutor = _getTutor();
  }

  Future<Paciente> _getPaciente() async {
    try {
      return await PacienteProvider().getPacienteById(widget.ficha.idPaciente!);
    } catch (e) {
      throw Exception('Error al obtener datos del paciente: $e');
    }
  }

  Future<Tutor> _getTutor() async {
    try {
      return await TutorProvider().getTutorById(widget.ficha.idTutor!);
    } catch (e) {
      throw Exception('Error al obtener datos del tutor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('N° Ficha ${widget.ficha.idFicha}'),
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddComentario(idFicha: widget.ficha.idFicha)),
                )
              },
              icon: Icon(MdiIcons.plus),
              iconSize: 30,
            ),
          )
        ],
      ),
      body: SizedBox(
        height: screenSize.height,
        child: FutureBuilder(
          future: Future.wait([_paciente, _tutor]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final paciente = snapshot.data![0] as Paciente;
              final tutor = snapshot.data![1] as Tutor;
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const TituloDetalle(text: 'Datos Tutor'),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textoStyle('Nombre: ${tutor.nombreTutor}'),
                        textoStyle('Celular: ${tutor.celular}'),
                        textoStyle('Dirección: ${tutor.direccion}'),
                        textoStyle('Rut: ${tutor.rut}')
                      ],
                    ),
                  ),
                  const TituloDetalle(text: 'Datos Paciente'),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textoStyle('Nombre: ${paciente.nombrePaciente}'),
                        textoStyle('Especie: ${paciente.especie}'),
                        textoStyle('Sexo: ${paciente.sexo}'),
                        textoStyle('Raza: ${paciente.raza}'),
                        textoStyle('Edad: ${paciente.edad}')
                      ],
                    ),
                  ),
                  const TituloDetalle(text: 'Historial'),
                  Expanded(
                    child: FutureBuilder(
                      future: ComentarioProvider()
                          .getComentarios(widget.ficha.idFicha!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final List<Comentario>? comentarios = snapshot.data;
                          if (comentarios != null && comentarios.isNotEmpty) {
                            return ListView.builder(
                              itemCount: comentarios.length,
                              itemBuilder: (context, index) {
                                final comentario = comentarios[index];
                                return GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.bodyBg,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  125, 0, 0, 0)
                                              .withOpacity(
                                                  0.5), // Color de la sombra
                                          spreadRadius:
                                              1, // Qué tanto se extiende la sombra desde el contenedor
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        comentario.tipoComentario,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21),
                                      ),
                                      subtitle: Text(
                                        comentario.comentario!,
                                        style: const TextStyle(
                                            color: AppColors.colorTextPrimary,
                                            fontSize: 15),
                                      ),
                                      trailing: Text(
                                        comentario.fecha!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.colorTextPrimary),
                                      ),
                                    ),
                                  ),
                                  onLongPress: () {
                                    mostrarConfirmacion(
                                        context, comentario.idComentario!);
                                  },
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('No hay comentarios'),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void mostrarConfirmacion(BuildContext context, int idTutor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Eliminar Comentario', style: TextStyle(fontSize: 26)),
          content: const Text(
            '¿Estás seguro que quieres eliminar este comentario?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () async {
                await ComentarioProvider().eliminarComentario(idTutor);
                // ignore: use_build_context_synchronously

                setState(() {
                  Navigator.of(context).pop();
                  mostrarSnackbar('Comentario Eliminado');
                });
                // Aquí puedes mostrar un mensaje o realizar alguna acción adicional
              },
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
          ],
        );
      },
    );
  }

  void mostrarSnackbar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Text(mensaje),
      ),
    );
  }

  Widget textoStyle(String text) {
    return Text(
      maxLines: 1,
      text,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.colorTextPrimary,
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    // Si el string es nulo, devuelve un DateTime nulo
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }
}
