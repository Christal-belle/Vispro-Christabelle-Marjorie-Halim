import 'package:flutter/material.dart';
import 'package:warung_digital/features/home/presentation/home_screen.dart';

void main() => runApp(const WarungApp());

class WarungApp extends StatelessWidget {
  const WarungApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(                       // installs theme, navigator, localisation
      title: 'Warung Digital',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF00696E),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}