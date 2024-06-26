//
//  Movie.swift
//  ios101-lab6-flix
//

import Foundation

struct MovieFeed: Decodable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let title: String
    let overview: String
    let posterPath: String?  // Path used to create a URL to fetch the poster image

    // MARK: Additional properties for detail view
    let backdropPath: String?  // Path used to create a URL to fetch the backdrop image
    let voteAverage: Double?
    let releaseDate: Date?

    // MARK: ID property to use when saving movie
    let id: Int

    // MARK: Custom coding keys
    // Allows us to map the property keys returned from the API that use underscores (i.e. `poster_path`)
    // to a more "swifty" lowerCamelCase naming (i.e. `posterPath` and `backdropPath`)
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case id
    }
}

extension Movie {
    static var favouriteKey: String {
        return "Favourites"
    }

    static func save(_ movies: [Movie], forKey key: String) {
        let defaults = UserDefaults.standard
        do {
            let encodedData = try JSONEncoder().encode(movies)
            defaults.setValue(encodedData, forKey: key)
        } catch {
            assertionFailure("encode movies error")
        }
    }

    static func getMovies(forKey key: String) -> [Movie] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key) {
            do {
                let decodedMovies = try JSONDecoder().decode([Movie].self, from: data)
                return decodedMovies
            } catch {
                assertionFailure("decoding movies error")
                return []
            }
        } else {
            return []
        }
    }
    
    func addToFavourites() {
        var favouriteMovies = Movie.getMovies(forKey: Movie.favouriteKey)
        favouriteMovies.append(self)
        Movie.save(favouriteMovies, forKey: Movie.favouriteKey)
    }
    
    func removeFromFavourites() {
        var favouriteMovies = Movie.getMovies(forKey: Movie.favouriteKey)
        favouriteMovies.removeAll { movie in
            return movie == self
        }
        Movie.save(favouriteMovies, forKey: Movie.favouriteKey)
    }
}
