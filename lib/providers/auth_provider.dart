import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  Profile? _profile;
  bool _loading = false;
  bool _initialized = false;
  String? _error;

  User? get user => _user;
  Profile? get profile => _profile;
  bool get loading => _loading;
  bool get initialized => _initialized;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (!rememberMe) {
      await _authService.signOut();
    }

    _user = _authService.currentUser;
    _authService.onAuthStateChange.listen(_onAuthStateChange);
    _initialized = true;
    notifyListeners();
  }

  void _onAuthStateChange(AuthState state) {
    _user = state.session?.user;
    if (_user != null && _profile == null) {
      _loadProfile();
    } else if (_user == null) {
      _profile = null;
      notifyListeners();
    }
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await _authService.getProfile();
    } catch (_) {
      _profile = null;
    }
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password, {bool rememberMe = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _authService.signInWithEmail(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', rememberMe);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password, String displayName) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _authService.signUpWithEmail(email, password, displayName);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', false);
    _user = null;
    _profile = null;
    notifyListeners();
  }

  Future<void> updateProfile({String? displayName, String? bio, String? avatarUrl}) async {
    try {
      _profile = await _authService.updateProfile(
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
