//
//  CityInputViewModel.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Combine

// `CityInputViewModel` conforms to `ObservableObject`, which allows SwiftUI views to observe changes in this object.
class CityInputViewModel: ObservableObject {
    // The `@Published` property wrapper notifies SwiftUI views when this property changes.
    @Published var cityName = ""
    @Published var weatherResponse: WeatherResponse?
    @Published var errorMessage: String?
    @Published var isLoading = false

    // A set to hold Combine's `AnyCancellable` objects to manage active subscriptions.
    private var cancellables = Set<AnyCancellable>()

    // `fetchWeather` triggers the process of fetching weather data.
    // It takes an optional completion handler that will execute once the operation is complete.
    func fetchWeather(completion: @escaping () -> Void = {}) {
        
        // Check if the city name is empty. If it is, set an error message and call the completion handler.
        guard !cityName.isEmpty else {
            errorMessage = "Please enter a valid city name"
            return
        }

        // Indicate that the data is being fetched by setting `isLoading` to `true`.
        isLoading = true
        // Fetch the geographic coordinates (latitude and longitude) of the given city name.
        GeocodingService.shared.fetchCoordinatesPublisher(for: cityName)
            // Chain a `flatMap` to the result to handle the output of the first publisher.
            .flatMap{ results -> AnyPublisher<WeatherResponse, Error> in
                // Check if any coordinates were returned. If not, emit a failure error.
                guard let result = results.first else {
                    return Fail(error: NSError(domain: "Invalid city name", code: -1, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                // If a valid coordinate is found, call the weather service to fetch the weather data.
                return WeatherService.shared.fetchWeatherPublisher(for: result.lat, lon: result.lon)
            }
            // Ensure the completion handler and UI updates happen on the main thread.
            .receive(on: DispatchQueue.main)
            // Subscribe to the data stream using `sink`, handling both the completion and value cases.
            .sink(receiveCompletion: { [weak self] completionResult in
                // Stop the loading indicator after the operation completes.
                self?.isLoading = false
                // If an error occurs, store it in `errorMessage` to be displayed in the UI.
                if case .failure(let error) = completionResult {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] weather in
                // Update the `weatherResponse` property with the fetched weather data.
                self?.weatherResponse = weather
                // Clear any error messages since the data was successfully fetched.
                self?.errorMessage = nil
                // Call the optional completion handler.
                completion()
            })
            // Store the `AnyCancellable` subscription to keep it alive until explicitly canceled.
            .store(in: &cancellables)
    }

    // `reset` clears the view model's state by resetting all relevant properties.
    func reset() {
        weatherResponse = nil
        errorMessage = nil
        isLoading = false
        // Remove all active Combine subscriptions.
        cancellables.removeAll()
    }
    
}
