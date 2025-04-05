import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_weather_app/viewmodels/search_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SearchViewModel viewModel;
  late MockWeatherService mockService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    mockService = MockWeatherService();
    viewModel = SearchViewModel();
    viewModel.overrideService(mockService);
  });

  test('search sets loading, then updates weather on success', () async {
    final fakeWeather = createFakeWeather();

    when(
      () => mockService.fetchWeatherByCity('Bucharest', isMetric: true),
    ).thenAnswer((_) async => fakeWeather);

    final future = viewModel.search('Bucharest');

    expect(viewModel.isLoading, true);
    await future;

    expect(viewModel.isLoading, false);
    expect(viewModel.weather, isNotNull);
    expect(viewModel.weather!.cityName, 'Bucharest');
    expect(viewModel.error, isNull);
  });

  test('search sets error on failed API call', () async {
    when(
      () => mockService.fetchWeatherByCity('Atlantis', isMetric: true),
    ).thenAnswer((_) async => null); // This simulates failed API

    await viewModel.search('Atlantis');

    expect(viewModel.weather, isNull);
    expect(viewModel.error, isNotNull);
  });

  test('toggleUnits switches between metric and imperial', () async {
    viewModel.overrideWeather(createFakeWeather());

    expect(viewModel.isMetric, true);

    when(
      () => mockService.fetchWeatherByCity(any(), isMetric: false),
    ).thenAnswer((_) async => createFakeWeather());

    viewModel.toggleUnits();

    expect(viewModel.isMetric, false);
  });

  test('toggleFavorite adds and removes city', () async {
    const city = 'Bucharest';

    expect(viewModel.favorites.contains(city), false);

    await viewModel.toggleFavorite(city);
    expect(viewModel.favorites.contains(city), true);

    await viewModel.toggleFavorite(city);
    expect(viewModel.favorites.contains(city), false);
  });
}
