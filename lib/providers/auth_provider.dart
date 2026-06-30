import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  Profile? _profile;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  Profile? get profile => _profile;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  AuthProvider() {
    _user = _authService.currentUser;
    _authService.onAuthStateChange.listen(_onAuthStateChange);
  }

  void _onAuthStateChange(AuthState state) {
    _user = state.session?.user;
    if (_user != null) {
      _loadProfile();
    } else {
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

  Future<void> signInWithEmail(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithEmail(email, password);
      await _loadProfile();
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
      await _authService.signUpWithEmail(email, password, displayName);
      await _loadProfile();
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
