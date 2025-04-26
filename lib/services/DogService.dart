import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tot_app/models/DogModel.dart';

class DogService {
  static Future<List<DogModel>> fetchDogs() async {
    final url = Uri.parse("https://www.freetestapi.com/api/v1/dogs");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DogModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load dogs");
    }
  }
}
