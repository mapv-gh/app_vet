import 'package:app_vet/model/cuenta_model.dart';
import 'package:app_vet/provider/cuenta_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuscarCuentas extends StatefulWidget {
  const BuscarCuentas({super.key});

  @override
  State<BuscarCuentas> createState() => _BuscarCuentasState();
}

class _BuscarCuentasState extends State<BuscarCuentas> {
  late TextEditingController searchController = TextEditingController();
  late List<Cuenta> _allCuentas = [];
  List<Cuenta> _filteredCuentas = [];
  bool _isLoading = false;

  void buscarCuenta() async {
    try {
      _isLoading = true;
      final List<Cuenta> allCuentas = await CuentaProvider().getAllCuentas();
      setState(() {
        _allCuentas = allCuentas;
        _isLoading = false;
      });
    } catch (e) {
      Text('Error al cargar las cuentas: $e');
    }
  }

  void _onSearchTextChanged() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      _filteredCuentas = [];
      if (searchTerm.isNotEmpty) {
        _filteredCuentas = _allCuentas.where((cuenta) {
          return cuenta.nombreCliente.toLowerCase().contains(searchTerm) ||
              cuenta.fecha.toLowerCase().contains(searchTerm);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    buscarCuenta();
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
            itemCount: _filteredCuentas.length,
            itemBuilder: (context, index) {
              if (_filteredCuentas.isNotEmpty) {
                final cuenta = _filteredCuentas[index];
                print(cuenta.fecha);
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
}
