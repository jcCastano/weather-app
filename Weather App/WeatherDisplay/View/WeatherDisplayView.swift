//
//  WeatherDisplayView.swift
//  Weather App
//
//  Created by Jc Castano on 5/7/24.
//

import SwiftUI

struct WeatherDisplayView: View {
    @StateObject private var viewModel: WeatherDisplayViewModel
    
    init(weatherResponse: WeatherResponse?) {
        _viewModel = StateObject(wrappedValue: WeatherDisplayViewModel(weatherResponse: weatherResponse))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.temperature).font(.largeTitle)
            Text(viewModel.description).font(.title)
            
            if let iconUrl = viewModel.iconURL {
                AsyncImage(url: iconUrl)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Weather Details")
    }
}
