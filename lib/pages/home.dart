import 'package:app_vet/components/card_home.dart';
import 'package:app_vet/pages/clientes_page.dart';
import 'package:app_vet/pages/cuentas_page.dart';
import 'package:app_vet/pages/pacientes_page.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " Vet Salud",
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
      ),
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top,
        child: Column(
          children: [
            Expanded(
              child: CardHome(
                text: 'Pacientes',
                page: const PacientesPage(),
                image: Image.asset(
                  'assets/images/cat.png',
                  width: 40,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            Expanded(
              child: CardHome(
                text: 'Cuentas',
                page: const CuentasPage(),
                image: Image.asset(
                  'assets/images/dolar.png',
                  width: 40,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            Expanded(
              child: CardHome(
                  text: 'Tutores',
                  page: const ClientesPage(),
                  image: Image.asset(
                    'assets/images/user.png',
                    width: 40,
                  )),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.bodyBg,
    );
  }
}
