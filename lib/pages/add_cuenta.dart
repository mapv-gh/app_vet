import 'package:app_vet/components/campo_texto.dart';
import 'package:app_vet/components/selector_fecha.dart';
import 'package:app_vet/provider/metodo_pago_provider.dart';
import 'package:app_vet/provider/provider.dart';
import 'package:app_vet/provider/tipo_cuenta_provider.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCuentaPage extends StatefulWidget {
  const AddCuentaPage({super.key});

  @override
  State<AddCuentaPage> createState() => _AddCuentaPageState();
}

class _AddCuentaPageState extends State<AddCuentaPage> {
  final TextEditingController nombreTutorController = TextEditingController();
  final TextEditingController precioController =
      TextEditingController(text: '0');
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController nombreClienteController = TextEditingController();

  String? selectTipo = '1';
  String? selectTipoPago = '1';
  late DateTime _fecha = DateTime.now();

  List<Map<String, dynamic>> _dataTipoCuenta = [];
  List<Map<String, dynamic>> _dataMetodoPago = [];

  void _actualizarFecha(DateTime nuevaFecha) {
    setState(() {
      _fecha = nuevaFecha;
    });
  }

  Future<void> _cargarTiposCuenta() async {
    final tiposCuenta = await TipoCuentaProvider().getTiposCuenta();
    setState(() {
      _dataTipoCuenta = tiposCuenta
          .map((tipo) => {
                'id_tipo_cuenta': tipo.idTipoCuenta,
                'nombre_tipo_cuenta': tipo.nombreTipoCuenta
              })
          .toList();
    });
  }

  Future<void> _cargarMetodoPago() async {
    final metodoPago = await MetodoPagoProvider().getMetodosPago();
    setState(() {
      _dataMetodoPago = metodoPago
          .map((metodo) => {
                'id_metodo_pago': metodo.idMetodoPago,
                'nombre_metodo_pago': metodo.nombreMetodoPago
              })
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarTiposCuenta();
    _cargarMetodoPago();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear pago'),
      ),
      backgroundColor: AppColors.bodyBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color.fromARGB(255, 237, 237, 237),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    hint: const Text(
                      'Seleccione origen de Cuenta',
                      style: TextStyle(
                          fontSize: 16, color: AppColors.colorTextPrimary),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    dropdownColor: const Color.fromARGB(255, 237, 237, 237),
                    style: const TextStyle(
                        color: AppColors.colorTextPrimary, fontSize: 20),
                    value: selectTipo,
                    items: _dataTipoCuenta.map((Map<String, dynamic> item) {
                      return DropdownMenuItem<String>(
                        value: item['id_tipo_cuenta'].toString(),
                        child: Text('${item['nombre_tipo_cuenta']}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectTipo = value.toString();
                      });
                    },
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color.fromARGB(255, 237, 237, 237),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    hint: const Text(
                      'Seleccione método de pago',
                      style: TextStyle(
                          fontSize: 16, color: AppColors.colorTextPrimary),
                    ),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    dropdownColor: const Color.fromARGB(255, 237, 237, 237),
                    style: const TextStyle(
                        color: AppColors.colorTextPrimary, fontSize: 20),
                    value: selectTipoPago,
                    items: _dataMetodoPago.map((Map<String, dynamic> item) {
                      return DropdownMenuItem<String>(
                        value: item['id_metodo_pago'].toString(),
                        child: Text('${item['nombre_metodo_pago']}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectTipoPago = value.toString();
                      });
                    },
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
              CampoTexto(
                controller: precioController,
                labelText: 'Precio',
                keyboardType: TextInputType.number,
              ),
              CampoTexto(
                  controller: nombreClienteController,
                  labelText: 'Nombre Cliente'),
              const SizedBox(
                height: 15,
              ),
              SelectorFecha(
                fechaInicial: _fecha,
                onFechaSeleccionada: _actualizarFecha,
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
                    int? precio = int.tryParse(precioController.text);
                    if (selectTipo != null &&
                        precio != null &&
                        precio > 0 &&
                        selectTipoPago != null) {
                      await _insertarCuenta(precio);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, true);
                    } else {
                      mostrarSnackbar('Rellena todos los campos');
                    }
                  },
                  child: const Text(
                    'Agregar pago',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _insertarCuenta(int precio) async {
    int idTipoCuenta = int.parse(selectTipo!);
    int idMetodoPago = int.parse(selectTipoPago!);

    final db = await DatabaseProvider().initDB();
    await db.insert('Cuenta', {
      'id_tipo_cuenta': idTipoCuenta,
      'id_metodo_pago': idMetodoPago,
      'precio': precio,
      'fecha': formatDate(DateTime.now()),
      'nombreCliente': nombreClienteController.text
    });

    mostrarSnackbar('Cuenta agregada correctamente');
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    final formatter = DateFormat('dd-MM-yy');
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
