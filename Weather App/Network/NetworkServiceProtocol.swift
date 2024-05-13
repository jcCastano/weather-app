//
//  NetworkServiceProtocol.swift
//  Weather App
//
//  Created by Jc Castano on 5/12/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        path: String,
        parameters: [String: Any]?,
        decodingType: T.Type
    ) -> AnyPublisher<T, Error>
}
