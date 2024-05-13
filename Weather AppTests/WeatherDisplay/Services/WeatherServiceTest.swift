//
//  WeatherServiceTest.swift
//  Weather AppTests
//
//  Created by Jc Castano on 5/13/24.
//

import XCTest

final class WeatherServiceTest: XCTestCase {

    func testExample() throws {
        let path = "data/2.5/weather"
        let lat = 39.9527
        let lon = -75.1635
        let exclude = "minutely,hourly,daily,alerts"
        let units = "imperial"
        let mockService = MockNetworkService()
        
        let service = WeatherService(networkService: mockService)
        let results = service.fetchWeatherPublisher(for: lat, lon: lon)
        
        XCTAssertEqual(mockService.path, path)
        XCTAssertEqual(mockService.parameters?["lat"] as! Double, lat)
        XCTAssertEqual(mockService.parameters?["lon"] as! Double, lon)
        XCTAssertEqual(mockService.parameters?["exclude"] as! String, exclude)
        XCTAssertEqual(mockService.parameters?["units"] as! String, units)
    }

}
