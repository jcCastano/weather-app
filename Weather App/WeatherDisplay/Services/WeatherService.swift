//
//  WeatherService.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Combine

// `WeatherService` is a singleton class responsible for fetching weather data using the OpenWeatherMap API.
final class WeatherService: NetworkService {
    // The shared instance of `WeatherService` to ensure there's only one globally accessible instance.
    static let shared = WeatherService()
    
    // `path` holds the specific endpoint for the weather data API.
    private let path = "data/2.5/weather"
    
    // Returns a publisher that fetches the weather data for the given latitude and longitude coordinates.
    func fetchWeatherPublisher(for lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        // Define the request parameters to include the coordinates, API key, and units.
        let parameters: [String: Any] = [
            "lat": lat, // Latitude for the weather data request.
            "lon": lon, // Longitude for the weather data request.
            "exclude": "minutely,hourly,daily,alerts", // Exclude unnecessary fields from the response.
            "units": "imperial" // Retrieve temperature in Fahrenheit (imperial units).
        ]

        // Calling 'request' with the specific path, parameters and decoding type. 
        return request(path: path, parameters: parameters, decodingType: WeatherResponse.self)
    }
    
}
