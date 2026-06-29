import 'package:flutter/material.dart';
import 'pages/login/login_page.dart';
import 'pages/homepage.dart';
import 'pages/profile/profile_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/recipes/recipes_page.dart';
import 'pages/market/market_page.dart';
import 'pages/store/store_page.dart';
import 'pages/my_recipes/my_recipes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Snails',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/recipes': (context) => const RecipesPage(),
        '/market': (context) => const MarketPage(),
        '/store': (context) => const StorePage(),
        '/my-recipes': (context) => const MyRecipesPage(),
      },
    );
  }
}
