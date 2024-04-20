import 'package:app_vet/model/ficha_model.dart';
import 'package:app_vet/pages/pacientes_detalle.dart';
import 'package:app_vet/provider/ficha_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BuscarPaciente extends StatefulWidget {
  const BuscarPaciente({super.key});

  @override
  State<BuscarPaciente> createState() => _BuscarPacienteState();
}

class _BuscarPacienteState extends State<BuscarPaciente> {
  late TextEditingController searchController = TextEditingController();
  late List<Ficha> _allFichas = [];
  List<Ficha> _filteredFichas = [];
  bool _isLoading = false;

  void buscarficha() async {
    try {
      _isLoading = true;
      final List<Ficha> allFichas = await FichaProvider().getAllFichas();
      setState(() {
        _allFichas = allFichas;
        _isLoading = false;
      });
    } catch (e) {
      Text('Error al cargar las Fichas: $e');
    }
  }

  void _onSearchTextChanged() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      _filteredFichas = [];
      if (searchTerm.isNotEmpty) {
        _filteredFichas = _allFichas.where((ficha) {
          return ficha.nombrePaciente!.toLowerCase().contains(searchTerm) ||
              ficha.nombreTutor!.toLowerCase().contains(searchTerm) ||
              ficha.idFicha!.toString().toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    buscarficha();
    searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double baseWidth = 375.0;
    double scale = screenSize.width / baseWidth;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar ficha'),
      ),
      body: Column(
        children: [
          Container(
            height: screenSize.height / 13,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: AppColors.colorTextPrimary),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(5),
            child: TextField(
              cursorColor: Colors.white,
              style: const TextStyle(color: AppColors.colorTextPrimary),
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar por Nombre o N° Ficha',
                hintStyle: TextStyle(color: AppColors.colorTextPrimary),
                fillColor: Colors.white,
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.search,
                  color: AppColors.colorTextPrimary,
                  size: 30,
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: _filteredFichas.length,
            itemBuilder: (context, index) {
              if (_filteredFichas.isNotEmpty) {
                final ficha = _filteredFichas[index];
                return Container(
                  alignment: Alignment.center,
                  width: screenSize.width,
                  height: screenSize.height / 8,
                  decoration: BoxDecoration(
                    color: AppColors.bodyBg,
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(125, 0, 0, 0).withOpacity(0.5),
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      maxLines: 1,
                      '${ficha.idPaciente}. ${ficha.nombreTutor} / ${ficha.nombrePaciente.toString()}',
                      style: TextStyle(
                          color: AppColors.colorTextPrimary,
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Fecha ingreso: ${formatDate(DateTime.tryParse(ficha.fecha!))}',
                      style: TextStyle(
                        color: AppColors.colorTextPrimary,
                        fontSize: 15 * scale,
                      ),
                    ),
                    trailing: Icon(
                      MdiIcons.arrowRight,
                      color: AppColors.colorTextPrimary,
                      size: 30,
                    ),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallePaciente(ficha: ficha),
                        ),
                      )
                    },
                  ),
                );
              } else {
                return _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox();
              }
            },
          )),
        ],
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
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
