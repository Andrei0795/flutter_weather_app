import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/favorites_tab/favorites_screen.dart';
import 'views/search_tab/search_screen.dart';
import 'views/settings_tab/settings_screen.dart';
import 'constants/app_strings.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  bool _useSystemTheme = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getBool('darkMode');

    setState(() {
      if (storedValue == null) {
        _useSystemTheme = true;
      } else {
        _isDarkMode = storedValue;
        _useSystemTheme = false;
      }
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
      _useSystemTheme = false;
    });
  }

  ThemeMode get effectiveThemeMode {
    if (_useSystemTheme) return ThemeMode.system;
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.app_title,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      darkTheme: ThemeData.dark().copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      themeMode: effectiveThemeMode,
      home: AnimatedTheme(
        data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Scaffold(
          body:
              [
                const SearchScreen(),
                const FavoritesScreen(),
                SettingsScreen(
                  isDarkMode:
                      _useSystemTheme
                          ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          : _isDarkMode,
                  onThemeChanged: _toggleDarkMode,
                ),
              ][_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: AppStrings.tabSearch,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: AppStrings.tabFavorites,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: AppStrings.tabSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
