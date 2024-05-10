//
//  WeatherDisplayViewModel.swift
//  Weather App
//
//  Created by Jc Castano on 5/8/24.
//

import Foundation

// View model that handles the business logic and data preparation for the WeatherDisplayView.
class WeatherDisplayViewModel: ObservableObject {
    // `@Published` properties will notify SwiftUI views to update when their values change.
    @Published var temperature: String
    @Published var description: String
    @Published var iconURL: URL?

    // Initializer that sets up the view model's properties based on the provided weather response.
    init(weatherResponse: WeatherResponse?) {
        // If a valid `weatherResponse` is provided, extract relevant data.
        if let weather = weatherResponse {
            // Format the temperature as a string with one decimal place and append "°F".
            temperature = String(format: "%.1f°F", weather.main.temp)
            // Use the first weather condition's description or fall back to a default if unavailable.
            description = weather.weather.first?.description ?? "No Description"
            // Construct the URL to the weather icon if available.
            if let icon = weather.weather.first?.icon {
                iconURL = URL(string: "https://openweathermap.org/img/w/\(icon).png")
            } else {
                iconURL = nil
            }
            
        } else {
            // If the weather response is `nil`, set default values indicating no data is available.
            temperature = "N/A"
            description = "No weather data available"
            iconURL = nil
        }
    }
}
