import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const WeatherCard({
    super.key,
    required this.weather,
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Image.network(weather.getIconUrl()),
        title: Text(weather.cityName),
        subtitle: Text(
          '${weather.temperature.toStringAsFixed(1)}° — ${weather.description}',
        ),
        trailing:
            onFavoriteToggle != null
                ? IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: onFavoriteToggle,
                )
                : null,
      ),
    );
  }
}
