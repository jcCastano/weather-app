//
//  WeatherService.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Alamofire
import Combine

// `WeatherService` is a singleton class responsible for fetching weather data using the OpenWeatherMap API.
final class WeatherService {
    // The shared instance of `WeatherService` to ensure there's only one globally accessible instance.
    static let shared = WeatherService()
    // Private initializer prevents other instances from being created, enforcing the singleton pattern.
    private init() {}

    // The API key needed to authenticate requests to OpenWeatherMap's API.
    private let apiKey: String = {
        Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String ?? ""
    }()
    // The base URL for the weather endpoint that returns current weather data.
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    // Returns a publisher that fetches the weather data for the given latitude and longitude coordinates.
    func fetchWeatherPublisher(for lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        // Define the request parameters to include the coordinates, API key, and units.
        let parameters: [String: Any] = [
            "lat": lat, // Latitude for the weather data request.
            "lon": lon, // Longitude for the weather data request.
            "exclude": "minutely,hourly,daily,alerts", // Exclude unnecessary fields from the response.
            "appid": apiKey, // API key for authentication.
            "units": "imperial" // Retrieve temperature in Fahrenheit (imperial units).
        ]

        // Make a GET request to the `baseUrl` with the specified parameters using Alamofire.
        return AF.request(baseUrl, parameters: parameters)
            // Validate the request to ensure it only accepts successful HTTP status codes.
            .validate()
            // Decode the JSON response into a `WeatherResponse` object using Combine's `Decodable` publisher.
            .publishDecodable(type: WeatherResponse.self)
            // Extract only the value from the publisher output.
            .value()
            // Convert any errors into the `Error` type for consistent error handling.
            .mapError { $0 as Error }
            // Type-erase the publisher to `AnyPublisher` to abstract away the specific publisher type.
            .eraseToAnyPublisher()
    }
    
}
