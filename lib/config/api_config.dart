import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get expressBaseUrl => dotenv.env['EXPRESS_BASE_URL'] ?? '';
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
