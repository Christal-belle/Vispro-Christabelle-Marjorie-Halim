import 'package:flutter/material.dart';
import 'package:watchlist/features/home /presentation/home_screen.dart';

class DramaWatchlistApp extends StatelessWidget {
  const DramaWatchlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drama Watchlist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
      ),
      home: const HomeScreen(),
    );
  }
}