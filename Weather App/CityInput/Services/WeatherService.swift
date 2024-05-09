//
//  WeatherService.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Alamofire
import Combine

final class WeatherService {
    static let shared = WeatherService()
    private init() {}
    
    private let apiKey = "8ad9ea8655058266976a5e32f05e2bdc"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeatherPublisher(for lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        let parameters: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "exclude": "minutely,hourly,daily,alerts",
            "appid": apiKey,
            "units": "imperial"
        ]

        return AF.request(baseUrl, parameters: parameters)
            .validate()
            .publishDecodable(type: WeatherResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
}
