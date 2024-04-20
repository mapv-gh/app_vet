import 'package:app_vet/components/campo_texto.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class AddClientesPage extends StatefulWidget {
  const AddClientesPage({super.key});

  @override
  State<AddClientesPage> createState() => _AddClientesPageState();
}

class _AddClientesPageState extends State<AddClientesPage> {
  final TextEditingController nombreTutorController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cliente'),
      ),
      backgroundColor: AppColors.bodyBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nombreTutorController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                    // Estilo para el texto del label
                    color:
                        AppColors.colorTextPrimary, // Color del texto del label
                  ),
                ),
                style: const TextStyle(
                  color:
                      AppColors.colorTextPrimary, // Color del texto ingresado
                ),
                cursorColor: AppColors.colorTextPrimary, // Color del cursor
              ),
              TextField(
                controller: celularController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Celular',
                  labelStyle: TextStyle(
                    // Estilo para el texto del label
                    color:
                        AppColors.colorTextPrimary, // Color del texto del label
                  ),
                ),
                style: const TextStyle(
                  color:
                      AppColors.colorTextPrimary, // Color del texto ingresado
                ),
                cursorColor: AppColors.colorTextPrimary, // Color del cursor
              ),
              TextField(
                controller: direccionController,
                decoration: const InputDecoration(
                  labelText: 'Direccion',
                  labelStyle: TextStyle(
                    // Estilo para el texto del label
                    color:
                        AppColors.colorTextPrimary, // Color del texto del label
                  ),
                ),
                style: const TextStyle(
                  color:
                      AppColors.colorTextPrimary, // Color del texto ingresado
                ),
                cursorColor: AppColors.colorTextPrimary, // Color del cursor
              ),
              CampoTexto(controller: rutController, labelText: 'Rut'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  iconSize: MaterialStateProperty.all(35),
                  // Color de fondo del botón
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.colorPrimary),
                  // Color del texto
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  // Padding
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  // Forma del botón
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // Sombra
                  elevation: MaterialStateProperty.all(10),
                ),
                onPressed: () {},
                child: const Text('Agregar cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
