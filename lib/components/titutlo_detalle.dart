import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class TituloDetalle extends StatelessWidget {
  final String text;
  const TituloDetalle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 5),
      width: screenSize.width,
      height: screenSize.height / 18,
      color: AppColors.appbarBg,
      child: Text(text,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500)),
    );
  }
}
