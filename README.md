# Weather App

This is a basic Weather Application built using Flutter. It fetches weather data from an external API and displays it to the user.

## Features

- Current weather information
- Temperature display
- Weather conditions (e.g., sunny, cloudy, rainy)
- City search functionality

## Installation

To run this application, follow the steps below:

### Prerequisites

- Ensure you have Flutter installed on your machine. If not, follow the instructions [here](https://flutter.dev/docs/get-started/install).

### Steps

1. **Clone the Repository**

    ```sh
    git clone https://github.com/undertaj/weather-app.git
    cd weather-app
    ```

2. **Install Dependencies**

    Navigate to the project directory and install the dependencies:

    ```sh
    flutter pub get
    ```

3. **Run the Application**

    Connect your device or start an emulator and run the application:

    ```sh
    flutter run
    ```

## Usage

- Open the app and enter the name of a city in the search bar.
- View the current weather information displayed for the city.

## Project Structure

```sh
weather-app/
├── android/
├── assets/
├── ios/
├── lib/
│   ├── app/
│   │   ├── core/
│   │   ├── data/
│   │   │   ├── bloc/
│   │   │   │   ├── location/
│   │   │   │   │   ├── location_bloc.dart
│   │   │   │   │   ├── location_event.dart
│   │   │   │   │   └── location_state.dart
│   │   │   │   ├── weather/
│   │   │   │   │   ├── weather_bloc.dart
│   │   │   │   │   ├── weather_event.dart
│   │   │   │   │   └── weather_state.dart
│   │   │   ├── models/
│   │   │   │   ├── location.dart
│   │   │   │   └── weather.dart
│   │   │   ├── repository/
│   │   │   │   ├── location_service.dart
│   │   │   │   └── weather_service.dart
│   │   ├── features/
│   │   │   ├── home/
│   │   │   ├── splash/
│   │   │   └── weather/
│   │   └── utils/
│   │       └── color.dart
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


