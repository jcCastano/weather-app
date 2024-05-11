//
//  NetworkService.swift
//  Weather App
//
//  Created by Jc Castano on 5/10/24.
//

import Foundation
import Combine

class NetworkService {
    // Base URL for all network requests
    private let baseUrl = URL(string: "https://api.openweathermap.org/")!
    
    // The API key is fetched from the app's Info.plist file, ensuring it is securely stored and easily configurable.
    private let apiKey: String = {
        Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String ?? ""
    }()
    
    // Function to perform a network GET request with path and parameters
    func request<T: Decodable>(
        path: String,
        parameters: [String: Any]? = nil,
        decodingType: T.Type
    ) -> AnyPublisher<T, Error> {
        // This constructs the full path URL by appending the endpoint path to the base URL.
        let fullPath = baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: fullPath)
        
        // If parameters are provided, they are merged with the API key. If not, a new dictionary is created containing only the API key.
        var allParameters = parameters ?? [:]
        allParameters["appid"] = apiKey
        
        // The parameters are encoded as URL query items. This method modifies the request to include these query parameters.
        request = encodeParameters(request: request, parameters: allParameters)
        
        // Perform the URL session data task and decode the response
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: decodingType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // This helper function takes a URLRequest and a dictionary of parameters. It encodes the parameters into the URL as query items.
    private func encodeParameters(request: URLRequest, parameters: [String: Any]) -> URLRequest {
        var encodedRequest = request
        // URLComponents is used to safely append query items to the URL, ensuring they are properly formatted and encoded.
        if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            encodedRequest.url = urlComponents.url
        }
        return encodedRequest
    }
}
