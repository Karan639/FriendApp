import 'package:dio/dio.dart';
import 'package:simpleapp/data/storage_services.dart';
import 'package:simpleapp/models/query.dart';
import 'package:simpleapp/models/user.dart';

class ApiServices {
  final Dio dio;
  final StorageService storageService;
  String? _authToken;

  ApiServices(this.dio, this.storageService) {
    dio.options.baseUrl = 'https://your-api-url.com'; // Replace with your actual API URL
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 30);
    
    // Add interceptor to automatically add auth token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = _authToken; // Note: Your API might not need 'Bearer' prefix
          }
          handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.response?.statusCode} - ${error.response?.data}');
          
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

  // Load saved token from storage
  Future<void> _loadSavedToken() async {
    final user = await storageService.getStoredUser();
    if (user != null) {
      _authToken = user.token;
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
  void _handleTokenExpired() async {
    clearAuthToken();
    await storageService.clearUser();
  }

  // Auth APIs
  Future<User> loginWithCredentials(String username, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      
      if (response.statusCode == 200 && response.data != null) {
        final user = User.fromLoginResponse(response.data, username);
        setAuthToken(user.token);
        
        // Save user data for persistent login
        await storageService.saveUser(user);
        
        return user;
      } else {
        throw Exception('Invalid login response');
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      
      if (e.response != null) {
        // Handle different HTTP status codes
        switch (e.response!.statusCode) {
          case 400:
            errorMessage = 'Invalid username or password';
            break;
          case 401:
            errorMessage = 'Unauthorized. Please check your credentials';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later';
            break;
          default:
            errorMessage = 'Login failed: ${e.response!.statusMessage}';
        }
      } else {
        errorMessage = 'Network error. Please check your connection';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    clearAuthToken();
    await storageService.clearUser();
  }

  // Get stored user if valid
  Future<User?> getStoredUser() async {
    return await storageService.getStoredUser();
  }

  // Query APIs
  Future<void> submitQuery(String subject, String description) async {
    try {
      final response = await dio.post('/customer/queries', data: {
        'subject': subject,
        'description': description,
      });
      
      if (response.statusCode != 201) {
        throw Exception('Failed to submit query');
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to submit query';
      
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            errorMessage = 'Invalid query data';
            break;
          case 401:
            errorMessage = 'Please login again';
            break;
          case 500:
            errorMessage = 'Server error. Please try again';
            break;
          default:
            errorMessage = 'Submit query failed: ${e.response!.statusMessage}';
        }
      } else {
        errorMessage = 'Network error. Please check your connection';
      }
      
      throw Exception(errorMessage);
    }
  }

  Future<List<Query>> getQueries({String status = 'OPEN'}) async {
    try {
      final response = await dio.get('/customer/queries', queryParameters: {
        'status': status,
      });
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> queryList = response.data;
        return queryList.map((json) => Query.fromJson(json)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch queries';
      
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 401:
            errorMessage = 'Please login again';
            break;
          case 500:
            errorMessage = 'Server error. Please try again';
            break;
          default:
            errorMessage = 'Fetch queries failed: ${e.response!.statusMessage}';
        }
      } else {
        errorMessage = 'Network error. Please check your connection';
      }
      
      throw Exception(errorMessage);
    }
  }

  // Dashboard API (placeholder - implement when you have the actual endpoint)
  Future<Map<String, dynamic>> getEnergyData() async {
    try {
      // Replace with your actual energy data endpoint when available
      final response = await dio.get('/dashboard/energy-data');
      return response.data;
    } catch (e) {
      // Return dummy data for now
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
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