import 'package:mocktail/mocktail.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:flutter_weather_app/models/weather.dart';

class MockWeatherService extends Mock implements WeatherService {}

Weather createFakeWeather() {
  return Weather(
    cityName: 'Bucharest',
    temperature: 20.5,
    description: 'Clear sky',
    icon: '01d',
    windSpeed: 3.5,
    feelsLike: 19.0,
    humidity: 50,
    pressure: 1015,
  );
}
