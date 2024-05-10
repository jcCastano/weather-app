//
//  CityInputView.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import SwiftUI

// This SwiftUI view serves as the input screen where users can enter the name of a city and fetch weather data.
struct CityInputView: View {
    // `@StateObject` creates and manages a view model that this view will observe for changes.
    @StateObject private var viewModel = CityInputViewModel()
    // `@State` property to control the navigation state for moving to the next screen.
    @State private var isShowingDetails = false

    // The main body of the SwiftUI view.
    var body: some View {
        // `NavigationView` provides a navigable container for pushing/popping views.
        NavigationView {
            // Vertical stack to arrange UI elements in a column.
            VStack {
                // A text field where users can enter the name of the city to fetch weather data.
                TextField("Enter city name", text: $viewModel.cityName)
                    // Add padding around the text field.
                    .padding()
                    // Apply a rounded border style to the text field.
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    // Disable autocorrection for more accurate city name entry.
                    .disableAutocorrection(true)

                // Display a loading indicator when the `isLoading` flag in the view model is `true`.
                if viewModel.isLoading {
                    ProgressView("Loading...").padding()
                }

                // If there's an error message, display it in red text.
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }

                // `NavigationLink` allows navigation to `WeatherDisplayView`.
                NavigationLink(
                    // Navigate to the `WeatherDisplayView` and pass the weather data from the view model.
                    destination: WeatherDisplayView(weatherResponse: viewModel.weatherResponse),
                    // Control navigation state using a `Binding` to `isShowingDetails`.
                    isActive: Binding(
                        // Getter returns the current value of `isShowingDetails`.
                        get: { isShowingDetails },
                        // Setter updates `isShowingDetails` and resets the view model if navigation is deactivated.
                        set: {
                            isShowingDetails = $0
                            if !isShowingDetails {
                                viewModel.reset()
                            }
                        }
                    )
                ) {
                    // Button to trigger the fetchWeather method in the view model.
                    Button("Fetch Weather") {
                        // Fetch weather data and navigate to the next screen if data is available.
                        viewModel.fetchWeather {
                            if viewModel.weatherResponse != nil {
                                isShowingDetails = true
                            }
                        }
                    }
                }
                .padding()

                // Fill the remaining vertical space with a spacer.
                Spacer()
            }
            // Add padding around all the inner elements of the VStack.
            .padding()
            // Set the title for the navigation bar.
            .navigationTitle("Weather Search")
        }
    }
}
