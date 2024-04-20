import 'package:app_vet/model/ficha_model.dart';
import 'package:app_vet/pages/add_paciente.dart';
import 'package:app_vet/pages/buscar_pacientes.dart';
import 'package:app_vet/pages/pacientes_detalle.dart';
import 'package:app_vet/provider/ficha_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PacientesPage extends StatefulWidget {
  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  final FichaProvider _fichaProvider = FichaProvider();
  late List<Ficha> _allFichas = [];
  bool _isLoading = false;
  final scrollController = ScrollController();
  int page = 1;
  final int perPage = 10;

  @override
  void initState() {
    super.initState();
    page = 1;
    _loadFichas(page, perPage);
    scrollController.addListener(_scrollListener);
  }

  Future<void> _loadFichas(int perPage, int page) async {
    try {
      _isLoading = true;
      final List<Ficha> allFichas =
          await _fichaProvider.getFichas(perPage, page);

      if (mounted) {
        setState(() {
          _allFichas = allFichas;
          _isLoading = false;
        });
      }
    } catch (e) {
      Text('Error al cargar las fichas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double baseWidth = 375.0;
    double scale = screenSize.width / baseWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pacientes',
          style: TextStyle(color: AppColors.textAppbarBg),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            page = 1;
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: AppColors.bodyBg,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 1))),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: screenSize.height / 13,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: AppColors.colorTextPrimary),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuscarPaciente(),
                          )),
                      cursorColor: Colors.white,
                      style: const TextStyle(color: AppColors.colorTextPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
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
                ),
                Container(
                  height: screenSize.height / 10,
                  width: screenSize.width * 0.5,
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    width: screenSize.width / 2,
                    height: screenSize.height / 10,
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddPacientePage()),
                          );
                          setState(() {
                            page = 1;
                            _loadFichas(page, perPage);
                          });
                        },
                        style: ButtonStyle(
                          iconSize: MaterialStateProperty.all(35),
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.colorButton),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(16)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Icon(MdiIcons.plus),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: _allFichas.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_allFichas.isNotEmpty) {
                  final Ficha ficha = _allFichas[index];
                  return Container(
                    alignment: Alignment.center,
                    width: screenSize.width,
                    height: screenSize.height / 8,
                    decoration: BoxDecoration(
                      color: AppColors.bodyBg,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(125, 0, 0, 0)
                              .withOpacity(0.5),
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
                } else if (_allFichas.isEmpty) {
                  return const Center(child: Text('No hay pacientes'));
                } else {
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoading = true;
        page += 1;
      });
      _loadFichas(perPage, page).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
