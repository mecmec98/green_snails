import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import 'api_client.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ApiClient _api = ApiClient();

  SupabaseClient get client => _supabase;
  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  Future<Profile> signInWithEmail(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
    return _syncProfile();
  }

  Future<Profile> signUpWithEmail(String email, String password, String displayName) async {
    await _supabase.auth.signUp(email: email, password: password, data: {'full_name': displayName});
    return _syncProfile();
  }

  Future<void> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'green-snails://auth/callback',
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<Profile> getProfile() async {
    final response = await _api.get('/auth/me');
    return Profile.fromJson(response['profile']);
  }

  Future<Profile> updateProfile({String? displayName, String? bio, String? avatarUrl}) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['display_name'] = displayName;
    if (bio != null) body['bio'] = bio;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;

    final response = await _api.put('/auth/me', body: body);
    return Profile.fromJson(response['profile']);
  }

  Future<Profile> _syncProfile() async {
    final response = await _api.post('/auth/sync-profile', body: {
      'display_name': _supabase.auth.currentUser?.userMetadata?['full_name'] ?? _supabase.auth.currentUser?.email,
    });
    return Profile.fromJson(response['profile']);
  }
}
