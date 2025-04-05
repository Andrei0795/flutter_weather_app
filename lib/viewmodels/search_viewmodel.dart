import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_strings.dart';

class SearchViewModel extends ChangeNotifier {
  WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _error;
  bool _isMetric = true;
  List<String> _suggestions = [];
  Set<String> _favorites = {};

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isMetric => _isMetric;
  List<String> get suggestions => _suggestions;
  Set<String> get favorites => _favorites;

  SearchViewModel() {
    loadFavorites();
  }

  @visibleForTesting
  void overrideService(WeatherService service) {
    _weatherService = service;
  }

  @visibleForTesting
  void overrideWeather(Weather weather) {
    _weather = weather;
    notifyListeners();
  }

  Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites.clear();
    await prefs.remove('favorites');
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites')?.toSet() ?? {};
    notifyListeners();
  }

  Future<void> toggleFavorite(String city) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(city)) {
      _favorites.remove(city);
    } else {
      _favorites.add(city);
    }
    await prefs.setStringList('favorites', _favorites.toList());
    notifyListeners();
  }

  bool isFavorite(String city) {
    return _favorites.contains(city);
  }

  Future<void> search(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _weatherService.fetchWeatherByCity(
        cityName,
        isMetric: _isMetric,
      );
      if (result != null) {
        _weather = result;
        _suggestions = [];
      } else {
        _error = AppStrings.weather_not_found;
        _weather = null;
      }
    } catch (e) {
      _error = AppStrings.general_error_title;
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSuggestions(String query) async {
    _suggestions = await _weatherService.fetchCitySuggestions(query);
    notifyListeners();
  }

  void toggleUnits() {
    _isMetric = !_isMetric;
    notifyListeners();
    if (_weather != null) {
      search(_weather!.cityName);
    }
  }

  void clear() {
    _weather = null;
    _error = null;
    _suggestions = [];
    notifyListeners();
  }
}
