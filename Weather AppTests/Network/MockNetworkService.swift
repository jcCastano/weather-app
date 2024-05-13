//
//  MockNetworkService.swift
//  Weather AppTests
//
//  Created by Jc Castano on 5/13/24.
//

import Foundation
import Combine

// A mock network service class that conforms to the NetworkServiceProtocol. This is used primarily for testing.
class MockNetworkService: NetworkServiceProtocol {
    // Variables to store the most recent request data.
    var path: String = ""
    var parameters: [String: Any]? = nil
    var decodingType: Any.Type? = nil
    
    // Function to handle network requests. It returns a publisher that will emit data according to the request type.
    func request<T>(
        path: String,
        parameters: [String: Any]?,
        decodingType: T.Type) -> AnyPublisher<T, any Error> where T: Decodable {
        // Store the request details for validation in tests.
        self.path = path
        self.parameters = parameters
        self.decodingType = decodingType
        
        // Switch on the path to determine which data to return.
        switch path {
        case "data/2.5/weather":
            // Attempt to cast the mock data to the expected return type (T). If successful, return it.
            if let mockWeatherData = mockWeatherData() as? T {
                return Just(mockWeatherData)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                // If casting fails, return a type mismatch error.
                return Fail(error: MockError.typeMismatch)
                    .eraseToAnyPublisher()
            }
        case "geo/1.0/direct":
            // Same handling as above but for geocoding data.
            if let mockGeocodingData = mockGeocodingData() as? T {
                return Just(mockGeocodingData)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: MockError.typeMismatch)
                    .eraseToAnyPublisher()
            }
        default:
            // If the path is not recognized, return an unknown path error.
            return Fail(error: MockError.unknownPath)
                .eraseToAnyPublisher()
        }
    }
    
    // Provides mock weather data, structured as a WeatherResponse.
    private func mockWeatherData() -> WeatherResponse {
        // Example JSON string representing weather data.
        let json = """
                    {
                        "main": {
                            "temp": 66.7
                        },
                        "weather": [
                            {
                                "description": "scattered clouds",
                                "icon": "03d"
                            }
                        ],
                        "name": "Philadelphia"
                    }
                    """
        let data = Data(json.utf8)
        return try! JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    // Provides mock geocoding data, structured as an array of GeocodingResult.
    private func mockGeocodingData() -> [GeocodingResult] {
        // Example JSON string representing geocoding data.
        let json = """
                    [
                        {
                            "lat": 39.9527,
                            "lon": -75.1635,
                            "name": "Philadelphia"
                        }
                    ]
                    """
        let data = Data(json.utf8)
        return try! JSONDecoder().decode([GeocodingResult].self, from: data)
    }
    
    // Custom errors used to describe failures in the mock network service.
    enum MockError: Error {
        case unknownPath  // Returned when the request path is not handled.
        case typeMismatch  // Returned when there's a type mismatch in casting the data.
    }
}
