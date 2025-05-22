import Foundation

class MovieService {
    static let shared = MovieService()
    private let apiService = APIRequestService.shared
    private var likedMovieIds: Set<Int> = []
    private var lastFetchTime: Date?
    
    private init() {}
    
    func getAllMovies() async throws -> [Movie] {
        return try await apiService.request(
            endpoint: "/movies",
            method: .get
        )
    }
    
    func getLikedMovies() async throws -> [Movie] {
        return try await apiService.request(
            endpoint: "/users/liked-movies",
            method: .get
        )
    }
    
    func likeMovie(id: Int) async throws {
        do {
            let _: EmptyResponse = try await apiService.request(
                endpoint: "/movies/like/\(id)",
                method: .post
            )
            // Update cached liked movie IDs
            likedMovieIds.insert(id)
        } catch APIError.alreadyLiked {
            // If movie is already liked, just update the cache
            likedMovieIds.insert(id)
        }
    }
    
    func unlikeMovie(id: Int) async throws {
        do {
            let _: EmptyResponse = try await apiService.request(
                endpoint: "/movies/unlike/\(id)",
                method: .post
            )
            // Update cached liked movie IDs
            likedMovieIds.remove(id)
        } catch APIError.notLiked {
            // If movie is not liked, just update the cache
            likedMovieIds.remove(id)
        }
    }
    
    func isMovieLiked(id: Int) async throws -> Bool {
        // Fetch liked movie IDs if not cached or cache is older than 30 seconds
        if likedMovieIds.isEmpty || lastFetchTime == nil || Date().timeIntervalSince(lastFetchTime!) > 30 {
            let likedIds: [Int] = try await apiService.request(
                endpoint: "/users/liked-movie-ids",
                method: .get
            )
            likedMovieIds = Set(likedIds)
            lastFetchTime = Date()
        }
        return likedMovieIds.contains(id)
    }
}

struct EmptyResponse: Codable {}

struct MovieLikeStatusResponse: Codable {
    let isLiked: Bool
}
