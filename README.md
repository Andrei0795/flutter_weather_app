# flutter_weather_app

A modern Flutter application that allows users to search for weather forecasts, toggle temperature units, manage favorites, and switch between light/dark themes — all wrapped in a clean MVVM architecture.

## Screenshots
<img width="180" alt="Screenshot 2024-05-28 at 23 40 47" src="https://github.com/user-attachments/assets/cdae9c05-9fc6-406e-b533-aee7a0c63008">
<img width="180" alt="Screenshot 2024-05-28 at 23 40 47" src="https://github.com/user-attachments/assets/5d7d67c4-9615-41aa-baa6-4e6cbd2b49c1">
<img width="180" alt="Screenshot 2024-05-28 at 23 40 47" src="https://github.com/user-attachments/assets/6e4a5f34-a8bc-41f9-89f3-2d3170dfb0c4">
<img width="180" alt="Screenshot 2024-05-28 at 23 40 47" src="https://github.com/user-attachments/assets/b32916e0-1f75-4024-a405-dd529988366d">

## Features

- **Search** for current weather in any city
- **Save favorites** and access them quickly
- **Toggle units**: Celsius ↔ Fahrenheit
- **Dark mode** toggle with system theme detection
- **Pull to refresh** the current weather
- **Settings tab** to control theme, clear favorites, and manage units
- Built using **MVVM architecture** with `provider`

## How to Run the App

### Prerequisites

- Flutter SDK installed — [Flutter Get Started Guide](https://flutter.dev/docs/get-started/install)
- A code editor like **VS Code** or **Android Studio**
- One of the following devices:
  - Android Emulator or physical Android device
  - iOS Simulator or iPhone (on macOS only)
  - Web browser (for Flutter Web build)

### Run on Android

Note: Make sure you have the simulator open. 

To get emulators run:

```bash
flutter emulators
```

To launch an emulator:

```bash
flutter emulators --launch Pixel_3a_API_36_extension_level_17_arm64-v8as
```
Obviously replace Pixel_3a_API_36_extension_level_17_arm64-v8as with the simulator name you have.

To run the app:

```bash
flutter run -d emulator-5554
```


Or use the device selector in your IDE.

### Run on iOS (macOS only)

Note: Make sure you have the simulator open. 

```bash
flutter run -d iPhone
```

Or:
```bash
open ios/Runner.xcworkspace
```

Then:
- Select a simulator or real device in Xcode
- Run the app using the ▶ button

Note: iOS deployment requires Xcode and Apple developer tools.

## Running Tests

This project includes **unit tests for the ViewModel layer**, including:

- Weather fetching
- Favorite management
- Unit toggling

Run all tests:

```bash
flutter test
```

## Architecture

- MVVM (Model-View-ViewModel) structure
- `SearchViewModel` for UI logic and state
- `WeatherService` to fetch data from OpenWeather API
- `shared_preferences` for persisting dark mode & favorites
- Clean, testable separation of UI and logic

## Weather API

This app uses the [OpenWeatherMap API](https://openweathermap.org/api) to fetch live weather data.

> Replace `YOUR_API_KEY` (or whatever key I provided there) in `weather_service.dart` with your actual API key.

