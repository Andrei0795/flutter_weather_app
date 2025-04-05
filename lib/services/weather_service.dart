import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_weather_app/models/weather.dart';

class WeatherService {
  static const String _apiKey =
      '5bacd6fa07f81fd902ba80dad57201a5'; // This is an API key that should be replaced. It is only temporary. 
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _geoUrl = 'https://api.openweathermap.org/geo/1.0';

  Future<Weather?> fetchWeatherByCity(
    String city, {
    bool isMetric = true,
  }) async {
    final units = isMetric ? 'metric' : 'imperial';
    final url = Uri.parse(
      '$_baseUrl/weather?q=$city&appid=$_apiKey&units=$units',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print('Weather fetch error: ${response.body}');
      return null;
    }
  }

  Future<List<String>> fetchCitySuggestions(String query) async {
    if (query.length < 3) return [];

    final url = Uri.parse('$_geoUrl/direct?q=$query&limit=5&appid=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<String>((item) {
        final name = item['name'];
        final country = item['country'];
        return '$name, $country';
      }).toList();
    } else {
      print('Suggestion error: ${response.body}');
      return [];
    }
  }
}
