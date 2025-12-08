import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dish.dart';
import '../models/dish_details.dart';

class ApiService {
  static const String _baseUrl = 'https://8b648f3c-b624-4ceb-9e7b-8028b7df0ad0.mock.pstmn.io/dishes/v1';

  // Fetches all dishes and popular dishes for the first screen
  Future<Map<String, dynamic>> fetchAllDishes() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<Dish> dishes = (jsonResponse['dishes'] as List)
          .map((e) => Dish.fromJson(e))
          .toList();
      final List<PopularDish> popularDishes = (jsonResponse['popularDishes'] as List)
          .map((e) => PopularDish.fromJson(e))
          .toList();
      
      return {'dishes': dishes, 'popularDishes': popularDishes};
    } else {
      throw Exception('Failed to load dishes');
    }
  }

  // Fetches details for a specific dish for the second screen
  Future<DishDetails> fetchDishDetails(int dishId) async {
    final response = await http.get(Uri.parse('$_baseUrl/$dishId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return DishDetails.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load dish details');
    }
  }
}