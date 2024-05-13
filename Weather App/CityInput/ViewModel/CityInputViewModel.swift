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
    @Published var geocodingResult: GeocodingResult?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    // A set to hold Combine's `AnyCancellable` objects to manage active subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // `fetchGeocoding` triggers the process of fetching geocoding data.
    // It takes an optional completion handler that will execute once the operation is complete.
    func fetchGeocoding(completion: @escaping () -> Void = {}) {
        
        // Check if the city name is empty. If it is, set an error message.
        guard !cityName.isEmpty else {
            errorMessage = "Please enter a valid city name"
            return
        }
        
        // Indicate that the data is being fetched by setting `isLoading` to `true`.
        isLoading = true
        let geocodingService = GeocodingService()
        // Fetch the geographic coordinates (latitude and longitude) of the given city name.
        geocodingService.fetchCoordinatesPublisher(for: cityName)
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
            }, receiveValue: { [weak self] results in
                if !results.isEmpty {
                    // Update the first geocoding result for the target location.
                    self?.geocodingResult = results.first
                    // Clear any error messages since the data was successfully fetched.
                    self?.errorMessage = nil
                    // Call the optional completion handler.
                } else {
                    self?.errorMessage = "City not found"
                }
                    
                completion()
            })
        // Store the `AnyCancellable` subscription to keep it alive until explicitly canceled.
            .store(in: &cancellables)
    }
    
    // `reset` clears the view model's state by resetting all relevant properties.
    func reset() {
        geocodingResult = nil
        errorMessage = nil
        isLoading = false
        // Remove all active Combine subscriptions.
        cancellables.removeAll()
    }
    
}
