import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../constants/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tabSettings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(AppStrings.theme_dark),
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
          SwitchListTile(
            title: Text(
              viewModel.isMetric
                  ? AppStrings.toggle_to_imperial
                  : AppStrings.toggle_to_metric,
            ),
            value: !viewModel.isMetric,
            onChanged: (value) {
              viewModel.toggleUnits();
            },
          ),
          ListTile(
            title: const Text(AppStrings.remove_favorites),
            trailing: const Icon(Icons.delete, color: Colors.red),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text(AppStrings.removeFavorites_alert_title),
                      content: const Text(AppStrings.removeFavorites_alert_message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(AppStrings.general_cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(AppStrings.general_delete),
                        ),
                      ],
                    ),
              );

              if (confirmed == true) {
                viewModel.clearAllFavorites();
              }
            },
          ),
        ],
      ),
    );
  }
}
