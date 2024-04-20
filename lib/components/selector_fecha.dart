import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesitas agregar la dependencia intl en pubspec.yaml

class SelectorFecha extends StatefulWidget {
  final DateTime fechaInicial;
  final Function(DateTime) onFechaSeleccionada;

  const SelectorFecha({
    super.key,
    required this.fechaInicial,
    required this.onFechaSeleccionada,
  });

  @override
  State<SelectorFecha> createState() => _SelectorFechaState();
}

class _SelectorFechaState extends State<SelectorFecha> {
  late DateTime _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = widget.fechaInicial;
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaEscogida = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada.isBefore(DateTime.now())
          ? DateTime.now()
          : _fechaSeleccionada, // Asegura que la fecha inicial no sea anterior a hoy
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
    );

    if (fechaEscogida != null && fechaEscogida != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = fechaEscogida;
      });
      widget.onFechaSeleccionada(_fechaSeleccionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatoFecha = DateFormat('dd-MM-yyy');
    return GestureDetector(
      onTap: () => _seleccionarFecha(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatoFecha.format(_fechaSeleccionada),
                style: const TextStyle(color: AppColors.colorTextPrimary)),
            const Icon(Icons.calendar_today_outlined,
                size: 20.0, color: AppColors.colorTextPrimary),
          ],
        ),
      ),
    );
  }
}
