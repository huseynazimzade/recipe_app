import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<dynamic>> fetchRecipes(String letter) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?f=$letter'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['meals'] as List<dynamic>? ?? [];
    } else {
      throw Exception('Məlumat yüklənərkən xəta baş verdi (Status: ${response.statusCode})');
    }
  }
}
