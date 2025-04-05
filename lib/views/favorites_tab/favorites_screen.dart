import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/weather_service.dart';
import '../../models/weather.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../widgets/weather_card.dart';
import '../search_tab/weather_detail_screen.dart';
import '../../constants/app_strings.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final WeatherService _weatherService = WeatherService();
  final Map<String, Weather?> _weatherMap = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() => _isLoading = true);
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    for (final city in viewModel.favorites) {
      final weather = await _weatherService.fetchWeatherByCity(
        city,
        isMetric: viewModel.isMetric,
      );
      _weatherMap[city] = weather;
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tabFavorites)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadWeather,
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.favorites.isEmpty
                  ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        AppStrings.no_favorites,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: viewModel.favorites.length,
                    itemBuilder: (context, index) {
                      final city = viewModel.favorites.elementAt(index);
                      final weather = _weatherMap[city];

                      if (weather == null) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: WeatherCard(
                          weather: weather,
                          isFavorite: viewModel.isFavorite(city),
                          onFavoriteToggle: () {
                            viewModel.toggleFavorite(city);
                            setState(() => _weatherMap.remove(city));
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        WeatherDetailScreen(weather: weather),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
