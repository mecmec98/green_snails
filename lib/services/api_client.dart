import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/api_config.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
    } catch (_) {}
    return headers;
  }

  void dispose() {
    _client.close();
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('${ApiConfig.expressBaseUrl}$path').replace(queryParameters: queryParams);
    final response = await _client.get(uri, headers: _headers());
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${ApiConfig.expressBaseUrl}$path');
    final response = await _client.post(uri, headers: _headers(), body: body != null ? jsonEncode(body) : null);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${ApiConfig.expressBaseUrl}$path');
    final response = await _client.put(uri, headers: _headers(), body: body != null ? jsonEncode(body) : null);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final uri = Uri.parse('${ApiConfig.expressBaseUrl}$path');
    final response = await _client.delete(uri, headers: _headers());
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.body.isEmpty) {
      if (response.statusCode >= 400) {
        throw Exception('Request failed with status ${response.statusCode}');
      }
      return {};
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response format');
    }

    if (response.statusCode >= 400) {
      final error = decoded['error'];
      final message = error is Map ? (error['message'] ?? 'Request failed') : 'Request failed';
      throw Exception(message);
    }

    return decoded;
  }
}
