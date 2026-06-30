import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/api_config.dart';
import 'providers/auth_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/market_provider.dart';
import 'providers/store_provider.dart';
import 'pages/login/login_page.dart';
import 'pages/homepage.dart';
import 'pages/profile/profile_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/recipes/recipes_page.dart';
import 'pages/market/market_page.dart';
import 'pages/store/store_page.dart';
import 'pages/my_recipes/my_recipes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: ApiConfig.supabaseUrl,
    anonKey: ApiConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Green Snails',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B5E20),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const AuthGate(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/recipes': (context) => const RecipesPage(),
          '/market': (context) => const MarketPage(),
          '/store': (context) => const StorePage(),
          '/my-recipes': (context) => const MyRecipesPage(),
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else if (data.event == AuthChangeEvent.signedOut) {
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return const HomePage();
    }
    return const LoginPage();
  }
}
