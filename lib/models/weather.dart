class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final double feelsLike;
  final int humidity;
  final int pressure;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
    );
  }

  String getIconUrl() => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
