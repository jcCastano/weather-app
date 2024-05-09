//
//  CityInputView.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import SwiftUI


struct CityInputView: View {
    @StateObject private var viewModel = CityInputViewModel()
    @State private var isShowingDetails = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter city name", text: $viewModel.cityName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                
                if viewModel.isLoading {
                    ProgressView("Loading...").padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                
                NavigationLink(
                    destination: WeatherDisplayView(weatherResponse: viewModel.weatherResponse),
                    isActive: Binding(
                        get: { isShowingDetails },
                        set: {
                            isShowingDetails = $0
                            if !isShowingDetails {
                                viewModel.reset()
                            }
                        }
                    )
                ) {
                    Button("Fetch Weather") {
                        viewModel.fetchWeather {
                            if viewModel.weatherResponse != nil {
                                isShowingDetails = true
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Weather Search")
        }
    }
}
