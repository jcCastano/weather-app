
# Weather App

The Weather App is an iOS application that displays detailed weather information for a specified location. Users can enter a city name and view the current weather conditions, including temperature, description, and a weather icon. The app retrieves data from the OpenWeatherMap API.

## Features

- Enter a city name to find weather details.
- View the temperature, weather description, and an icon representing the weather condition.
- Swipe down to refresh and get the latest weather information.

## Prerequisites

- **Xcode**: Make sure you have Xcode installed (version 12.5 or later recommended).
- **Swift**: The app is written in Swift, so no additional installations are needed.
- **OpenWeatherMap API Key**: An API key from [OpenWeatherMap](https://openweathermap.org/api) is required to access the weather data.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/jcCastano/weather-app.git
   ```
2. **Navigate to the Project Directory**:
   ```bash
   cd weather-app
   ```
3. **Install CocoaPods**:
   - If CocoaPods isn't installed, you can install it using:
   ```bash
   sudo gem install cocoapods
   ```
   - Run `pod install` to fetch dependencies.

4. **Open the Workspace**:
   - Open the `Weather App.xcworkspace` file using Xcode.

5. **Add Your API Key**:
   - Go to the `Info.plist` file in the Xcode project navigator.
   - Add a new key-value pair with the following:
     - **Key**: `WEATHER_API_KEY`
     - **Value**: Your OpenWeatherMap API key (e.g., `8ad9ea8655058266976a5e32f05e2bdc`).

## Usage

1. **Build and Run**:
   - Select the appropriate simulator or connected device in Xcode.
   - Click the "Run" button or press `Cmd + R` to build and launch the app.

2. **Get Weather Details**:
   - Enter the name of a city in the input field.
   - Tap the "Fetch Weather" button to view detailed weather information.
   - Swipe down to refresh the weather data.

## Notes

- **GeocodingService**:
  - The app uses the Geocoding API to convert city names into geographic coordinates, which are then used to fetch weather details.

- **WeatherService**:
  - The app uses the Weather API to fetch weather data using Combine and Alamofire.

- **Architecture**:
  - The app employs the MVVM design pattern to maintain a clear separation between UI and business logic.

- **SwiftUI**:
  - The user interface is built entirely using SwiftUI for a modern and declarative approach.

