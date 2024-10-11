import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio; // Make dio nullable

  // Initialize Dio with the correct base URL for TheMealDB API
  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.themealdb.com/api/json/v1/1/', // The correct base URL for the API
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(milliseconds: 5000), // Timeout for connecting to the server
        receiveTimeout: const Duration(milliseconds: 3000), // Timeout for receiving response
      ),
    );
  }

  // Generic method to get data from any endpoint with optional query parameters
  static Future<Response?> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await dio?.get(url, queryParameters: query);
      if (response?.statusCode == 200) {
        return response;
      } else {
        print('Error: ${response?.statusCode} - ${response?.statusMessage}');
        return null; // You can also throw an error here
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  // Method to get a recipe by its ID from TheMealDB API
  static Future<Response?> getRecipeById(String id) async {
    return await getData(url: 'lookup.php', query: {'i': id});
  }

  // Method to search for recipes by name
  static Future<Response?> searchRecipesByName(String name) async {
    return await getData(url: 'search.php', query: {'s': name});
  }

  // Method to get all categories from TheMealDB API
  static Future<Response?> getCategories() async {
    return await getData(url: 'categories.php');
  }
}
