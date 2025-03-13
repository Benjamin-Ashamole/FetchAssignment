//
//  APIService.swift
//  FetchTakeHomeAssignment
//
//  Created by Benjamin Ashamole on 3/12/25.
//

import Foundation

protocol APIServiceProtocol { }

enum ServiceError: Error {
    case serverError
    case decodingError
}

class APIService: APIServiceProtocol {
    var session: URLSession
    
    static let shared = APIService()
    
    private init(session: URLSession = ServiceHelper.getURLSession()) {
        self.session = session
    }
    
    func makeRequest<T:Codable>(_ request: URLRequest, returnModel: T.Type) async throws -> Result<T, ServiceError> {
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...300) ~= httpResponse.statusCode else {
            return .failure(ServiceError.serverError)
        }
        
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return .success(data)
        } catch {
            print("Decoding Failure", error)
            return .failure(ServiceError.decodingError)
        }
    }
}

enum ServiceCallStatus {
    case idle
    case loading
}

protocol ApiCalling {
    func makeURLRequest(for action: RecipeServiceAction) throws -> URLRequest
}

class ServiceHelper {
    static func getURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.tlsMinimumSupportedProtocolVersion = .TLSv12
        return URLSession(configuration: config)
    }
}
