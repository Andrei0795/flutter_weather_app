import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../widgets/weather_card.dart';
import 'weather_detail_screen.dart';
import '../../constants/app_strings.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.general_weather)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Field
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: AppStrings.search_hint),
                onChanged: (value) {
                  if (value.length >= 3) {
                    viewModel.updateSuggestions(value);
                  } else {
                    viewModel.clear();
                  }
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    viewModel.search(value);
                  }
                },
              ),

              // Suggestions
              if (viewModel.suggestions.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = viewModel.suggestions[index];
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        _controller.text = suggestion;
                        viewModel.search(suggestion);
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),

              const SizedBox(height: 16),

              // Weather & refresh
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (viewModel.weather != null) {
                      await viewModel.search(viewModel.weather!.cityName);
                    }
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (viewModel.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (viewModel.error != null)
                        Center(
                          child: Text(
                            viewModel.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      else if (viewModel.weather != null)
                        WeatherCard(
                          weather: viewModel.weather!,
                          isFavorite: viewModel.isFavorite(
                            viewModel.weather!.cityName,
                          ),
                          onFavoriteToggle: () {
                            viewModel.toggleFavorite(
                              viewModel.weather!.cityName,
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => WeatherDetailScreen(
                                      weather: viewModel.weather!,
                                    ),
                              ),
                            );
                          },
                        )
                      else
                        const Center(
                          child: Text(AppStrings.search_placeholder),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
