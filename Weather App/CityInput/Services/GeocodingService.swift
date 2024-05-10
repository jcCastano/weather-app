//
//  GeocodingService.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Alamofire
import Combine

// `GeocodingService` is a singleton class responsible for fetching geographic coordinates for a given city name using the OpenWeatherMap API.
final class GeocodingService {
    // The shared instance ensures that only one instance of `GeocodingService` is created and accessed throughout the app.
    static let shared = GeocodingService()
    // Private initializer prevents external instances, enforcing the singleton pattern.
    private init() {}

    // The API key required for authenticating requests to the OpenWeatherMap Geocoding API.
    private let apiKey = "8ad9ea8655058266976a5e32f05e2bdc"
    // The base URL to the OpenWeatherMap geocoding endpoint.
    private let geocodeUrl = "https://api.openweathermap.org/geo/1.0/direct"

    // This function returns a publisher that fetches geographic coordinates for a given city name.
    func fetchCoordinatesPublisher(for city: String) -> AnyPublisher<[GeocodingResult], Error> {
        // Define the request parameters to include the city name, API key, and result limit.
        let parameters: [String: String] = [
            "q": city, // The city name to search for coordinates.
            "limit": "1", // Limit the results to 1 for efficiency.
            "appid": apiKey // API key required for authentication.
        ]

        // Make a GET request to the `geocodeUrl` with the specified parameters using Alamofire.
        return AF.request(geocodeUrl, parameters: parameters)
            // Validate the request to ensure only successful HTTP status codes are accepted.
            .validate()
            // Decode the JSON response into an array of `GeocodingResult` objects using Combine's `Decodable` publisher.
            .publishDecodable(type: [GeocodingResult].self)
            // Extract only the value from the publisher output.
            .value()
            // Convert any Alamofire errors into the `Error` type for consistent error handling.
            .mapError {$0 as Error}
            // Type-erase the publisher to `AnyPublisher` to abstract away the specific publisher type.
            .eraseToAnyPublisher()
    }
}

