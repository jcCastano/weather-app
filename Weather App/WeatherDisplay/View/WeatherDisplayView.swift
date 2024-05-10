//
//  WeatherDisplayView.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import SwiftUI

// A SwiftUI view that displays detailed weather information, such as temperature and condition description.
struct WeatherDisplayView: View {
    // A state object to observe changes in the view model, updating the view automatically when changes occur.
    @StateObject private var viewModel: WeatherDisplayViewModel
    
    // Custom initializer that accepts a `WeatherResponse` object and initializes the view model.
    init(weatherResponse: WeatherResponse?) {
        // Initializes the view model using a wrapped value, allowing it to be used as a state object.
        _viewModel = StateObject(wrappedValue: WeatherDisplayViewModel(weatherResponse: weatherResponse))
    }
    
    // The main body of the SwiftUI view.
    var body: some View {
        // Vertically arrange the elements with 16 points of spacing between them.
        VStack(spacing: 16) {
            // Display the temperature as a large title.
            Text(viewModel.temperature).font(.largeTitle)
            // Display the weather condition description as a title.
            Text(viewModel.description).font(.title)
            
            // Check if the view model has a valid URL for the weather icon.
            if let iconUrl = viewModel.iconURL {
                // Use `AsyncImage` to load and display the weather icon asynchronously.
                AsyncImage(url: iconUrl)
                    // Maintain the image's aspect ratio and fit it within the frame.
                    .aspectRatio(contentMode: .fit)
                    // Limit the size of the image to 100x100 points.
                    .frame(width: 100, height: 100)
            }
            
            // Spacer fills the remaining vertical space below, pushing content to the top.
            Spacer()
        }
        // Add padding around the entire vertical stack.
        .padding()
        // Set the navigation title to "Weather Details".
        .navigationTitle("Weather Details")
    }
}
