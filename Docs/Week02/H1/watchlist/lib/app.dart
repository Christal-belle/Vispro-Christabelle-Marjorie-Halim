import 'package:flutter/material.dart';
import 'package:watchlist/features/home /presentation/home_screen.dart';
import 'core/theme/app_theme.dart';

class DramaWatchlistApp extends StatelessWidget {
  const DramaWatchlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drama Watchlist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      
      home: const HomeScreen(),
    );
  }
}