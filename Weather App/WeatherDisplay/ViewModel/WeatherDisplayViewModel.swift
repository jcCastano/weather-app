//
//  WeatherDisplayViewModel.swift
//  Weather App
//
//  Created by Jc Castano on 5/8/24.
//

import Foundation
import Combine

// View model that handles the business logic and data preparation for the WeatherDisplayView.
class WeatherDisplayViewModel: ObservableObject {
    // `@Published` properties will notify SwiftUI views to update when their values change.
    @Published var temperature: String
    @Published var description: String
    @Published var iconURL: URL?
    
    // A set to hold Combine's `AnyCancellable` objects, which manage active subscriptions.
    private var cancellables = Set<AnyCancellable>()
    // Stores the geocoding result, which contains the latitude and longitude coordinates of the desired location.
    private var geocodingResult: GeocodingResult?
    
    // Initializer that sets up the view model's properties based on the provided `GeocodingResult`.
    init(geocodingResult: GeocodingResult?) {
        // Store the provided geocoding result for future use in fetching weather data.
        self.geocodingResult = geocodingResult
        // Initialize `temperature` and `description` with placeholders indicating loading status.
        temperature = "Loading..."
        description = "Fetching weather data..."
        iconURL = nil
        
        // Fetch the weather data based on the given coordinates.
        refresh()
    }
    
    // Fetch weather data using `WeatherService`.
    func refresh() {
        // Check if the geocoding result is available to obtain coordinates.
        if let geocoding = geocodingResult {
            let weatherService = WeatherService()
            // Make a network request to fetch weather data for the given coordinates.
            weatherService.fetchWeatherPublisher(for: geocoding.lat, lon: geocoding.lon)
            // Ensure that Combine publisher output is processed on the main thread for UI updates.
                .receive(on: DispatchQueue.main)
            // Handle completion (errors) and received values.
                .sink(receiveCompletion: { completion in
                    // Handle any errors during the data retrieval process.
                    if case .failure(let error) = completion {
                        print("Error fetching weather data: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] weatherResponse in
                    // Update the view model properties with the fetched weather data.
                    self?.updateWeatherData(weatherResponse: weatherResponse)
                })
            // Store the subscription to prevent cancellation while active.
                .store(in: &cancellables)
        }
    }
    
    // Updates the temperature, description, and icon URL properties using the provided `WeatherResponse`.
    private func updateWeatherData(weatherResponse: WeatherResponse?) {
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
