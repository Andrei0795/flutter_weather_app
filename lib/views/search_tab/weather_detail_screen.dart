import 'package:flutter/material.dart';
import '../../models/weather.dart';
import '../../constants/app_strings.dart';

class WeatherDetailScreen extends StatelessWidget {
  final Weather weather;

  const WeatherDetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${weather.cityName} ${AppStrings.general_details}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.network(weather.getIconUrl(), scale: 0.7),
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°',
                    style: const TextStyle(fontSize: 32),
                  ),
                  Text(
                    weather.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.general_more_details,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('${AppStrings.humidity}', '${weather.humidity}%'),
            _buildInfoRow('${AppStrings.pressure}', '${weather.pressure} hPa'),
            _buildInfoRow('${AppStrings.wind_speed}', '${weather.windSpeed} m/s'),
            _buildInfoRow(
              '${AppStrings.feels_like}',
              '${weather.feelsLike.toStringAsFixed(1)}°',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
