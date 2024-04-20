import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CardHome extends StatelessWidget {
  final String text;
  final dynamic page;
  final Image image;
  const CardHome(
      {super.key, required this.text, required this.page, required this.image});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double baseWidth = 375.0;
    double scale = screenSize.height / baseWidth;
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                image,
                Text(
                  '  $text',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15 * scale),
                ),
                const Spacer(),
                Icon(
                  MdiIcons.arrowRight,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        )
      },
    );
  }
}
