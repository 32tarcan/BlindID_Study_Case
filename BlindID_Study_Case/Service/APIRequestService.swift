import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidURL
    case unauthorized
    case invalidResponse
    case serverError(message: String)
    case decodingError(message: String)
    case alreadyLiked
    case notLiked
}

class APIRequestService {
    static let shared = APIRequestService()
    private let baseUrl = "https://moviatask.cerasus.app/api"
    
    private init() {}
    
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if requiresAuth {
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print("\(endpoint) Response Status Code: \(httpResponse.statusCode)")
        print("\(endpoint) Response Data: \(String(data: data, encoding: .utf8) ?? "")")
        
        if (200...299).contains(httpResponse.statusCode) {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(message: error.localizedDescription)
            }
        }
        else if httpResponse.statusCode == 400 {
            do {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                if endpoint.contains("/like/") {
                    if errorResponse.message.contains("already liked") {
                        if let emptyResponse = EmptyResponse() as? T {
                            return emptyResponse
                        }
                        throw APIError.alreadyLiked
                    }
                } else if endpoint.contains("/unlike/") {
                    if errorResponse.message.contains("not liked") {
                        if let emptyResponse = EmptyResponse() as? T {
                            return emptyResponse
                        }
                        throw APIError.notLiked
                    }
                }
                throw APIError.serverError(message: errorResponse.message)
            } catch {
                if let apiError = error as? APIError {
                    throw apiError
                }
                throw APIError.serverError(message: "Request failed with status code: \(httpResponse.statusCode)")
            }
        } else {
            do {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw APIError.serverError(message: errorResponse.message)
            } catch {
                throw APIError.serverError(message: "Request failed with status code: \(httpResponse.statusCode)")
            }
        }
    }
} 
