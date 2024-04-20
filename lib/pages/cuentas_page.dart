import 'package:app_vet/pages/buscar_cuentas.dart';
import 'package:flutter/material.dart';
import 'package:app_vet/model/cuenta_model.dart';
import 'package:app_vet/pages/add_cuenta.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:app_vet/provider/cuenta_provider.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CuentasPage extends StatefulWidget {
  const CuentasPage({super.key});

  @override
  State<CuentasPage> createState() => _CuentasPageState();
}

class _CuentasPageState extends State<CuentasPage> {
  final CuentaProvider _cuentaProvider = CuentaProvider();
  late final ScrollController _scrollController = ScrollController();
  late List<Cuenta> _allCuentas = [];
  bool _isLoading = false;
  int page = 1;
  final int perPage = 10;

  @override
  void initState() {
    super.initState();
    page = 1;
    _loadCuentas(perPage, page);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadCuentas(int perPage, int page) async {
    try {
      final List<Cuenta> allCuentas =
          await _cuentaProvider.getCuentas(perPage, page);
      setState(() {
        _allCuentas = allCuentas;
      });
    } catch (e) {
      Text('Error al cargar las cuentas: $e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoading = true;
        page += 1;
      });
      _loadCuentas(perPage, page).then((_) {
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
        title: const Text('Cuentas'),
        centerTitle: true,
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
                            builder: (context) => const BuscarCuentas(),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddCuentaPage()));
                          setState(() {
                            _loadCuentas(perPage, page);
                          });
                        },
                        style: ButtonStyle(
                          iconSize: MaterialStateProperty.all(35),
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.appbarBg),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
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
            itemCount: _allCuentas.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (_allCuentas.isNotEmpty) {
                final cuenta = _allCuentas[index];
                return ListTile(
                  title: Text(
                    '${cuenta.nombreTipoCuenta}',
                    style: const TextStyle(
                        color: AppColors.colorTextPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    'Cliente: ${cuenta.nombreCliente}\nM. Pago: ${cuenta.nombreMetodoPago} \n${cuenta.fecha}',
                    style: const TextStyle(
                        color: AppColors.colorTextPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  trailing: Text(
                    '\$${formatPrice(cuenta.precio)}',
                    style: const TextStyle(
                      color: AppColors.colorTextPrimary,
                      fontSize: 16,
                    ),
                  ),
                  onLongPress: () {
                    mostrarConfirmacion(context, cuenta.idCuenta!);
                  },
                );
              } else if (_allCuentas.isEmpty) {
                return const Center(
                  child: Text('No hay pagos'),
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

  void mostrarConfirmacion(BuildContext context, int idCuenta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Pago', style: TextStyle(fontSize: 26)),
          content: const Text(
            '¿Estás seguro que quieres eliminar este pago?',
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
                await CuentaProvider().deleteCuenta(idCuenta);
                // ignore: use_build_context_synchronously

                setState(() {
                  Navigator.of(context).pop();
                  mostrarSnackbar('Pago Eliminado');
                  _loadCuentas(perPage, page);
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

  String formatPrice(int? price) {
    if (price == null) return '';
    final formatter = NumberFormat.currency(
      decimalDigits: 0,
      locale: 'es_CL',
      symbol: '',
    );
    return formatter.format(price);
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
