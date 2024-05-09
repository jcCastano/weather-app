//
//  GeocodingService.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Alamofire
import Combine

final class GeocodingService {
    static let shared = GeocodingService()
    private init() {}

    private let apiKey = "8ad9ea8655058266976a5e32f05e2bdc"
    private let geocodeUrl = "https://api.openweathermap.org/geo/1.0/direct"
    
    func fetchCoordinatesPublisher(for city: String) -> AnyPublisher<[GeocodingResult], Error> {
        let parameters: [String: String] = [
            "q": city,
            "limit": "1",
            "appid": apiKey
        ]
        
        return AF.request(geocodeUrl, parameters: parameters)
            .validate()
            .publishDecodable(type: [GeocodingResult].self)
            .value()
            .mapError {$0 as Error}
            .eraseToAnyPublisher()
    }
}

