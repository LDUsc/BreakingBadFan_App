//
//  APIError.swift
//  CA_Project1-LukasUD
//
//  Created by Lukas Uscila Dainavicius on 25/02/2021.
//

enum APIError: Error {
    case failedRequest
    case unexpectedDataFormat
    case failedURLCreation
    var errorDescription: String {
        switch self {
        case .failedRequest:
            return "API Request has failed"
        case .unexpectedDataFormat:
            return "Could not decode online data"
        case .failedURLCreation:
            return "Could not create URL"
        }
    }
}
