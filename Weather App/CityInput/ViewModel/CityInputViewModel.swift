//
//  CityInputViewModel.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import Foundation
import Combine

class CityInputViewModel: ObservableObject {
    @Published var cityName = ""
    @Published var weatherResponse: WeatherResponse?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather(completion: @escaping () -> Void = {}) {
        
        guard !cityName.isEmpty else {
            errorMessage = "Please enter a valid city name"
            completion()
            return
        }
        
        isLoading = true
        GeocodingService.shared.fetchCoordinatesPublisher(for: cityName)
            .flatMap{ results -> AnyPublisher<WeatherResponse, Error> in
                guard let result = results.first else {
                    return Fail(error: NSError(domain: "Invalid city name", code: -1, userInfo: nil))
                        .eraseToAnyPublisher()
                }
                return WeatherService.shared.fetchWeatherPublisher(for: result.lat, lon: result.lon)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionResult in
                self?.isLoading = false
                if case .failure(let error) = completionResult {
                    self?.errorMessage = error.localizedDescription
                }
                completion()
            }, receiveValue: { [weak self] weather in
                self?.weatherResponse = weather
                self?.errorMessage = nil
                completion()
            })
            .store(in: &cancellables)
    }
    
    func reset() {
            weatherResponse = nil
            errorMessage = nil
            isLoading = false
            cancellables.removeAll()
        }
    
}
