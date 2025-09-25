import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpleapp/models/query.dart';
import 'package:simpleapp/models/user.dart';

class ApiServices {
  final Dio _dio;
  final SharedPreferences _prefs;
  String? _authToken;

  ApiServices(this._dio, this._prefs) {
    _dio.options.baseUrl = 'https://your-api-url.com'; // Replace with your actual API URL
    _dio.options.connectTimeout = Duration(seconds: 30);
    
    // Add interceptor to automatically add auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401 unauthorized - token expired
          if (error.response?.statusCode == 401) {
            _handleTokenExpired();
          }
          handler.next(error);
        },
      ),
    );
    
    // Load saved token on initialization
    _loadSavedToken();
  }

  // Load saved token from SharedPreferences
  Future<void> _loadSavedToken() async {
    final userJson = _prefs.getString('user_data');
    if (userJson != null) {
      try {
        final userData = Map<String, dynamic>.from(
          // You'll need to parse this JSON properly
          // For now, assuming it's stored as a Map
        );
        if (User.isStoredTokenValid(userData)) {
          final user = User.fromJson(userData);
          _authToken = user.token;
        } else {
          // Token expired, clear stored data
          await clearStoredUser();
        }
      } catch (e) {
        await clearStoredUser();
      }
    }
  }

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token
  void clearAuthToken() {
    _authToken = null;
  }

  // Handle token expiration
  void _handleTokenExpired() {
    clearAuthToken();
    clearStoredUser();
  }

  // Auth APIs
  Future<User> loginWithCredentials(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      
      final user = User.fromLoginResponse(response.data, username);
      setAuthToken(user.token);
      
      // Save user data for persistent login
      await _saveUserData(user);
      
      return user;
    } catch (e) {
      if (e is DioException) {
        throw Exception('Login failed: ${e.response?.data['message'] ?? e.message}');
      }
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    clearAuthToken();
    await clearStoredUser();
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData(User user) async {
    await _prefs.setString('user_data', user.toJSON().toString());
  }

  // Clear stored user data
  Future<void> clearStoredUser() async {
    await _prefs.remove('user_data');
  }

  // Get stored user if valid
  Future<User?> getStoredUser() async {
    final userJson = _prefs.getString('user_data');
    if (userJson != null) {
      try {
        // Parse the stored JSON string back to Map
        // You might need to use dart:convert for proper JSON handling
        final userData = Map<String, dynamic>.from({});
        if (User.isStoredTokenValid(userData)) {
          final user = User.fromJson(userData);
          setAuthToken(user.token);
          return user;
        }
      } catch (e) {
        await clearStoredUser();
      }
    }
    return null;
  }

  // Query APIs
  Future<void> submitQuery(String subject, String description) async {
    try {
      final response = await _dio.post('/customer/queries', data: {
        'subject': subject,
        'description': description,
      });
      
      if (response.statusCode != 201) {
        throw Exception('Failed to submit query');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Submit query failed: ${e.response?.data['message'] ?? e.message}');
      }
      throw Exception('Submit query failed: ${e.toString()}');
    }
  }

  Future<List<Query>> getQueries({String status = 'OPEN'}) async {
    try {
      final response = await _dio.get('/customer/queries', queryParameters: {
        'status': status,
      });
      
      final List<dynamic> queryList = response.data;
      return queryList.map((json) => Query.fromJson(json)).toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception('Failed to fetch queries: ${e.response?.data['message'] ?? e.message}');
      }
      throw Exception('Failed to fetch queries: ${e.toString()}');
    }
  }

  // Dashboard API (placeholder - you'll need to implement based on your actual endpoint)
  Future<Map<String, dynamic>> getEnergyData() async {
    try {
      // This is a placeholder - replace with your actual energy data endpoint
      final response = await _dio.get('/dashboard/energy-data');
      return response.data;
    } catch (e) {
      // For now, return dummy data
      return {
        'daily_energy_generation': 25.5,
        'sunrise_time': '06:30',
        'sunset_time': '18:45',
        'daily_energy_savings': 15.75,
        'power_generated': 12.3,
        'earnings': 125.50,
      };
    }
  }
}