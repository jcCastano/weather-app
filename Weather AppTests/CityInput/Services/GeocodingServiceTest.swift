//
//  GeocodingServiceTest.swift
//  Weather AppTests
//
//  Created by Jc Castano on 5/13/24.
//

import XCTest

final class GeocodingServiceTest: XCTestCase {

    func testExample() throws {
        let path = "geo/1.0/direct"
        let city = "Philadelphia"
        let mockService = MockNetworkService()
        
        let service = GeocodingService(networkService: mockService)
        let results = service.fetchCoordinatesPublisher(for: city)
        
        XCTAssertEqual(mockService.path, path)
        XCTAssertEqual(mockService.parameters?["q"] as! String, city)
        XCTAssertEqual(mockService.parameters?["limit"] as! String, "1")
        XCTAssert(mockService.decodingType is [GeocodingResult].Type)
    }

}
