import 'package:app_vet/components/campo_texto.dart';
import 'package:app_vet/components/titutlo_detalle.dart';
import 'package:app_vet/model/tutor_model.dart';
import 'package:app_vet/provider/tutor_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class EditTutorPage extends StatefulWidget {
  final int id;

  const EditTutorPage({super.key, required this.id});

  @override
  State<EditTutorPage> createState() => _EditTutorPageState();
}

class _EditTutorPageState extends State<EditTutorPage> {
  final TutorProvider _tutorProvider = TutorProvider();
  final TextEditingController nombreTutorController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController nombrePacienteController =
      TextEditingController();
  final TextEditingController rutController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadTutorData();
  }

  void _loadTutorData() async {
    try {
      Tutor tutor = await _tutorProvider.getTutorById(widget.id);
      setState(() {
        nombreTutorController.text = tutor.nombreTutor!;
        direccionController.text = tutor.direccion!;
        celularController.text = tutor.celular!;
        rutController.text = tutor.rut!;
      });
    } catch (e) {
      Text('Error al cargar datos del tutor: $e');
    }
  }

  void _saveChanges() async {
    try {
      Tutor updatedTutor = Tutor(
        idTutor: widget.id,
        nombreTutor: nombreTutorController.text,
        direccion: direccionController.text,
        celular: celularController.text,
        rut: rutController.text,
      );
      await _tutorProvider.updateTutor(updatedTutor);
      // Mostrar mensaje de éxito o navegar de regreso a la página anterior
    } catch (e) {
      Text('Error al guardar cambios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarBg,
      ),
      backgroundColor: AppColors.bodyBg,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const TituloDetalle(text: 'Datos Tutor'),
            CampoTexto(
              controller: nombreTutorController,
              labelText: 'Nombre del Tutor',
            ),
            CampoTexto(
              controller: direccionController,
              labelText: 'Dirección',
            ),
            CampoTexto(
              controller: celularController,
              labelText: 'Celular',
            ),
            CampoTexto(
              controller: rutController,
              labelText: 'Rut',
            ),
            const SizedBox(height: 11),
            ElevatedButton(
              style: ButtonStyle(
                iconSize: MaterialStateProperty.all(35),
                backgroundColor:
                    MaterialStateProperty.all(AppColors.colorPrimary),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                elevation: MaterialStateProperty.all(10),
              ),
              onPressed: () async {
                final nombreTutor = nombreTutorController.text;
                final nombrePaciente = nombreTutorController.text;
                final celular = celularController.text.toString();
                final direccion = direccionController.text;
                try {
                  if (nombreTutor.isNotEmpty &&
                      nombrePaciente.isNotEmpty &&
                      celular.isNotEmpty &&
                      direccion.isNotEmpty &&
                      nombrePaciente.isNotEmpty) {
                    _saveChanges();
                    // ignore: use_build_context_synchronously
                    setState(() {
                      Navigator.pop(context, true);
                      mostrarSnackbar('Datos Modificados');
                    });
                  } else {
                    mostrarSnackbar('Ingrese todos los datos');
                  }
                } catch (e) {
                  mostrarSnackbar('Error al realizar la inserción\nError: $e');
                }
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
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
}
