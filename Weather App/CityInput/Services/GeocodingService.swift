//
//  GeocodingService.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Combine

// `GeocodingService` is a singleton class responsible for fetching geographic coordinates for a given city name using the OpenWeatherMap API.
final class GeocodingService {
    
    private let networkService: NetworkServiceProtocol
    private var limit: Int
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         limit: Int = 1
    ) {
        self.networkService = networkService
        self.limit = limit
    }
    
    // 'path' is a private constant that stores the specific endpoint for the geocoding API.
    private let path = "geo/1.0/direct"
    
    // This function returns a publisher that fetches geographic coordinates for a given city name.
    func fetchCoordinatesPublisher(for city: String) -> AnyPublisher<[GeocodingResult], Error> {
        // Define the request parameters to include the city name and result limit.
        let parameters = [
            "q": city, // The city name to search for coordinates.
            "limit": String(limit), // Limit the results to 1 for efficiency.
        ]

        // Calling 'request' with the specific path, parameters and decoding type. 
        return networkService.request(path: path, parameters: parameters, decodingType: [GeocodingResult].self)
    }
}

