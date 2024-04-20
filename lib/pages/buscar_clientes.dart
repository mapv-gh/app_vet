import 'package:app_vet/model/tutor_model.dart';
import 'package:app_vet/pages/edit_cliente.dart';
import 'package:app_vet/provider/tutor_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BuscarClientes extends StatefulWidget {
  const BuscarClientes({super.key});

  @override
  State<BuscarClientes> createState() => _BuscarClientesState();
}

class _BuscarClientesState extends State<BuscarClientes> {
  final TutorProvider _tutorProvider = TutorProvider();
  late TextEditingController searchController = TextEditingController();
  late List<Tutor> _filteredTutores = [];
  late List<Tutor> _allTutores = [];
  bool _isLoading = false;

  void _onSearchTextChanged() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      _filteredTutores = [];
      if (searchTerm.isNotEmpty) {
        _filteredTutores = _allTutores.where((tutor) {
          return tutor.nombreTutor!.toLowerCase().contains(searchTerm) ||
              tutor.idTutor!.toString().contains(searchTerm);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadTutores();
    searchController.addListener(_onSearchTextChanged);
  }

  Future<void> _loadTutores() async {
    try {
      _isLoading = true;
      final List<Tutor> allTutores = await _tutorProvider.getAllTutors();
      setState(() {
        _allTutores = allTutores;
        _isLoading = false;
      });
    } catch (e) {
      Text('Error al cargar los tutores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Cuenta'),
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
                hintText: 'Buscar por Nombre de cliente o fecha',
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
                itemCount: _filteredTutores.length,
                itemBuilder: (context, index) {
                  if (_filteredTutores.isNotEmpty) {
                    final tutor = _filteredTutores[index];
                    return ListTile(
                      title: Text(
                        '${tutor.idTutor}. ${tutor.nombreTutor}',
                        style: const TextStyle(
                            color: AppColors.colorTextPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Direccion: ${tutor.direccion}',
                            style: const TextStyle(
                                color: AppColors.colorTextPrimary,
                                fontSize: 18),
                          ),
                          Text(
                            'Celular: ${tutor.celular}',
                            style: const TextStyle(
                                color: AppColors.colorTextPrimary,
                                fontSize: 18),
                          ),
                          Text(
                            'Rut: ${tutor.rut}',
                            style: const TextStyle(
                                color: AppColors.colorTextPrimary,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            MdiIcons.pen,
                            color: AppColors.colorPrimary,
                            size: 30,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditTutorPage(id: tutor.idTutor!)),
                            );
                          }),
                    );
                  } else {
                    return _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox();
                  }
                }),
          )
        ],
      ),
    );
  }
}
