import 'package:app_vet/model/tutor_model.dart';
import 'package:app_vet/pages/buscar_clientes.dart';
import 'package:app_vet/pages/edit_cliente.dart';
import 'package:app_vet/provider/tutor_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final TutorProvider _tutorProvider = TutorProvider();

  late final ScrollController _scrollController = ScrollController();
  late List<Tutor> _allTutores = [];

  bool _isLoading = true;
  int page = 1;
  final int perPage = 10;

  @override
  void initState() {
    super.initState();
    page = 1;
    _loadTutores(perPage, page);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadTutores(int perPage, int page) async {
    try {
      final List<Tutor> allTutores =
          await _tutorProvider.getTutors(perPage, page);
      setState(() {
        _allTutores = allTutores;
      });
    } catch (e) {
      Text('Error al cargar los tutores: $e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoading = true;
        page += 1;
      });
      _loadTutores(perPage, page).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarBg,
        title: const Text('Tutores'),
        centerTitle: true,
      ),
      backgroundColor: AppColors.bodyBg,
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
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuscarClientes(),
                  )),
              cursorColor: Colors.white,
              style: const TextStyle(color: AppColors.colorTextPrimary),
              decoration: const InputDecoration(
                hintText: 'Buscar tutor...',
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
                itemCount: _allTutores.length + (_isLoading ? 1 : 0),
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (_allTutores.isNotEmpty) {
                    final tutor = _allTutores[index];
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
                  } else if (_allTutores.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
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
