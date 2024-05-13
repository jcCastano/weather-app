//
//  WeatherService.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Combine

// `WeatherService` is a singleton class responsible for fetching weather data using the OpenWeatherMap API.
final class WeatherService {
    private let networkService: NetworkServiceProtocol
    private let exclude: String
    private let units: String
    
    // `path` holds the specific endpoint for the weather data API.
    private let path = "data/2.5/weather"
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         exclude: String = "minutely,hourly,daily,alerts",
         units: String = "imperial"
    ) {
        self.networkService = networkService
        self.exclude = exclude
        self.units = units
    }
    
    // Returns a publisher that fetches the weather data for the given latitude and longitude coordinates.
    func fetchWeatherPublisher(for lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        // Define the request parameters to include the coordinates, API key, and units.
        let parameters: [String: Any] = [
            "lat": lat, // Latitude for the weather data request.
            "lon": lon, // Longitude for the weather data request.
            "exclude": exclude, // Exclude unnecessary fields from the response.
            "units": units // Retrieve temperature in Fahrenheit (imperial units).
        ]

        // Calling 'request' with the specific path, parameters and decoding type. 
        return networkService.request(path: path, parameters: parameters, decodingType: WeatherResponse.self)
    }
    
}
