//
//  WeatherDisplayViewModel.swift
//  Weather App
//
//  Created by Jc Castano on 5/8/24.
//

import Foundation

class WeatherDisplayViewModel: ObservableObject {
    @Published var temperature: String
    @Published var description: String
    @Published var iconURL: URL?
    
    init(weatherResponse: WeatherResponse?) {
        if let weather = weatherResponse {
            temperature = String(format: "%.1f°F", weather.main.temp)
            description = weather.weather.first?.description ?? "No Description"
            if let icon = weather.weather.first?.icon {
                iconURL = URL(string: "https://openweathermap.org/img/w/\(icon).png")
            } else {
                iconURL = nil
            }
            
        } else {
            temperature = "N/A"
            description = "No weather data available"
            iconURL = nil
        }
    }
}
