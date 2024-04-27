import 'package:app_vet/components/campo_texto.dart';
import 'package:app_vet/components/titutlo_detalle.dart';
import 'package:app_vet/provider/provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class AddPacientePage extends StatefulWidget {
  const AddPacientePage({super.key});

  @override
  State<AddPacientePage> createState() => _AddPacientePageState();
}

class _AddPacientePageState extends State<AddPacientePage> {
  final TextEditingController nombreTutorController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController nombrePacienteController =
      TextEditingController();
  final TextEditingController especieController = TextEditingController();
  final TextEditingController razaController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController rutController = TextEditingController();

  String generoSeleccionado = 'M';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarBg,
        title: const Text('Agregar Paciente'),
      ),
      backgroundColor: AppColors.bodyBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const TituloDetalle(text: 'Datos Paciente'),
              CampoTexto(
                controller: nombrePacienteController,
                labelText: 'Nombre del Paciente',
              ),
              CampoTexto(
                controller: especieController,
                labelText: 'Especie',
              ),
              CampoTexto(
                controller: razaController,
                labelText: 'Raza',
              ),
              CampoTexto(
                controller: edadController,
                labelText: 'Edad',
              ),
              Container(
                width: screenSize.width,
                padding: const EdgeInsets.only(top: 10),
                child: const Text('Sexo'),
              ),
              Container(
                width: screenSize.width,
                margin: EdgeInsets.only(right: screenSize.width * 0.75),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color.fromARGB(255, 237, 237, 237),
                ),
                child: DropdownButton<String>(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  hint: const Text(
                    'Seleccione Sexo',
                    style: TextStyle(
                        fontSize: 16, color: AppColors.colorTextPrimary),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  dropdownColor: const Color.fromARGB(255, 237, 237, 237),
                  style: const TextStyle(
                      color: AppColors.colorTextPrimary, fontSize: 20),
                  value: generoSeleccionado,
                  onChanged: (newValue) {
                    setState(() {
                      generoSeleccionado = newValue!;
                    });
                  },
                  items: <String>['M', 'H'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.appbarBg),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(16)),
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
                    final especie = especieController.text;
                    final raza = razaController.text;
                    final edad = edadController.text;
                    final celular = celularController.text.toString();
                    final direccion = direccionController.text;
                    try {
                      if (nombreTutor.isNotEmpty &&
                          nombrePaciente.isNotEmpty &&
                          celular.isNotEmpty &&
                          direccion.isNotEmpty &&
                          nombrePaciente.isNotEmpty &&
                          especie.isNotEmpty &&
                          raza.isNotEmpty &&
                          edad.isNotEmpty) {
                        final idTutor = await _insertarTutor();
                        final idPaciente = await _insertarPaciente();
                        await _insertFicha(idTutor, idPaciente);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, true);
                        mostrarSnackbar('Paciente agregado correctamente');
                      } else {
                        mostrarSnackbar('Ingrese todos los datos');
                      }
                    } catch (e) {
                      mostrarSnackbar(
                          'Error al realizar la inserción\nError: $e');
                    }
                  },
                  child: const Text('Agregar paciente',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 11),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _insertFicha(int idTutor, int idPaciente) async {
    final db = await DatabaseProvider().initDB();
    return db.insert('Ficha', {
      'id_tutor': idTutor,
      'id_paciente': idPaciente,
      'fecha': DateTime.now().toString()
    });
  }

  Future<int> _insertarPaciente() async {
    String sexo = generoSeleccionado == 'M' ? 'Macho' : 'Hembra';
    final db = await DatabaseProvider().initDB();
    return db.insert('Paciente', {
      'nombre_paciente': nombrePacienteController.text,
      'raza': razaController.text,
      'especie': especieController.text,
      'edad': edadController.text,
      'sexo': sexo,
    });
  }

  Future<int> _insertarTutor() async {
    final db = await DatabaseProvider().initDB();
    return db.insert('Tutor', {
      'nombre_tutor': nombreTutorController.text,
      'celular': celularController.text,
      'direccion': direccionController.text,
      'rut': rutController.text,
    });
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
