import 'package:app_vet/pages/home.dart';
import 'package:app_vet/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Veterinaria Vet Salud',
        theme: ThemeData(
          textTheme: GoogleFonts.arOneSansTextTheme(),
          scaffoldBackgroundColor: AppColors.bodyBg,
          appBarTheme: const AppBarTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              iconTheme: IconThemeData(color: AppColors.textAppbarBg),
              centerTitle: true,
              backgroundColor: AppColors.appbarBg,
              titleTextStyle: TextStyle(
                color: AppColors.textAppbarBg,
                fontSize: 30,
              )),
          useMaterial3: true,
        ),
        home: const Home());
  }
}
