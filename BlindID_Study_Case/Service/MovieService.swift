import Foundation

class MovieService {
    static let shared = MovieService()
    private let baseUrl = "https://moviatask.cerasus.app/api"
    
    private init() {}
    
    func getAllMovies() async throws -> [Movie] {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw MovieError.unauthorized
        }
        
        let url = URL(string: "\(baseUrl)/movies")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieError.invalidResponse
        }
        
        print("Get All Movies Response Status Code: \(httpResponse.statusCode)")
        print("Get All Movies Response Data: \(String(data: data, encoding: .utf8) ?? "")")
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode([Movie].self, from: data)
        } else {
            throw MovieError.serverError(message: "Failed to fetch movies")
        }
    }
    
    func getLikedMovies() async throws -> [Movie] {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw MovieError.unauthorized
        }
        
        let url = URL(string: "\(baseUrl)/users/liked-movies")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieError.invalidResponse
        }
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode([Movie].self, from: data)
        } else {
            throw MovieError.serverError(message: "Failed to fetch liked movies")
        }
    }
    
    func isMovieLiked(id: Int) async throws -> Bool {
        let likedMovies = try await getLikedMovies()
        return likedMovies.contains { $0.id == id }
    }
    
    func getMovieById(id: Int) async throws -> Movie {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw MovieError.unauthorized
        }
        
        let url = URL(string: "\(baseUrl)/movies/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieError.invalidResponse
        }
        
        print("Get Movie Response Status Code: \(httpResponse.statusCode)")
        print("Get Movie Response Data: \(String(data: data, encoding: .utf8) ?? "")")
        
        if httpResponse.statusCode == 200 {
            do {
                return try JSONDecoder().decode(Movie.self, from: data)
            } catch {
                print("Error decoding movie: \(error)")
                
                // Try unwrapping from a container
                do {
                    let container = try JSONDecoder().decode(MovieResponse.self, from: data)
                    return container.movieData
                } catch {
                    print("Error decoding MovieResponse: \(error)")
                    throw MovieError.decodingError(message: "Could not parse movie data: \(error.localizedDescription)")
                }
            }
        } else if httpResponse.statusCode == 401 {
            throw MovieError.unauthorized
        } else {
            throw MovieError.serverError(message: "Failed to fetch movie with status code: \(httpResponse.statusCode)")
        }
    }
    
    func likeMovie(id: Int) async throws {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw MovieError.unauthorized
        }
        
        let url = URL(string: "\(baseUrl)/movies/like/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw MovieError.serverError(message: "Failed to like movie")
        }
    }
    
    func unlikeMovie(id: Int) async throws {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            throw MovieError.unauthorized
        }
        
        let url = URL(string: "\(baseUrl)/movies/unlike/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw MovieError.serverError(message: "Failed to unlike movie")
        }
    }
}
