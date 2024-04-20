import 'package:app_vet/components/campo_texto.dart';
import 'package:app_vet/provider/provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddComentario extends StatefulWidget {
  final int? idFicha;
  const AddComentario({
    super.key,
    required this.idFicha,
  });

  @override
  State<AddComentario> createState() => _AddComentarioState();
}

class _AddComentarioState extends State<AddComentario> {
  final TextEditingController descripcionController = TextEditingController();
  String? selectTipo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Comentario',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color.fromARGB(255, 237, 237, 237),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  dropdownColor: const Color.fromARGB(255, 237, 237, 237),
                  style: const TextStyle(color: AppColors.colorTextPrimary),
                  value: selectTipo,
                  hint: const Text(
                    'Selecciona tipo de atención',
                    textAlign: TextAlign.end,
                  ),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'Consulta',
                      child: Text(
                        'Consulta',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Control',
                      child: Text(
                        'Control',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Interpretación de exámanes',
                      child: Text(
                        'Interpretación de exámanes',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Control telefónico',
                      child: Text(
                        'Control telefónico',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Solo exámenes',
                      child: Text(
                        'Solo exámenes',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectTipo = value;
                    });
                  },
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
            CampoTexto(
                controller: descripcionController, labelText: 'Descripción'),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  iconSize: MaterialStateProperty.all(35),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 94, 235, 69)),
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
                  if (selectTipo != null && descripcionController.text != '') {
                    await _insertComentario();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, true);
                  } else {
                    mostrarSnackbar('Rellena todos los campos');
                  }
                },
                child: const Text('Agregar Comentario',
                    style: TextStyle(fontSize: 18)),
              ),
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

  Future<void> _insertComentario() async {
    final db = await DatabaseProvider().initDB();
    await db.insert('Comentario', {
      'tipo_comentario': selectTipo,
      'id_ficha': widget.idFicha,
      'fecha': formatDate(DateTime.now()),
      'comentario': descripcionController.text
    });
    mostrarSnackbar('Comentario agregado correctamente');
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final formatter = DateFormat('dd-MM-yy');
    return formatter.format(date);
  }
}
