//
//  Movie.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 15.06.2022.
//

import Foundation

struct User: Codable {
  let page: Int
  let results: [Result]
}

struct Result: Codable, Hashable {
  let adult: Bool
  let backdropPath: String
  let genreIDS: [Int]
  let id: Int
  let originalLanguage, originalTitle, overview: String
  let popularity: Double
  let posterPath: String?
  let releaseDate, title: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
  
  
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case genreIDS = "genre_ids"
    case id
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview, popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title, video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  func relaseYear() -> String? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyy-MM-dd"
      if let dateFromString = dateFormatter.date(from: releaseDate) {
          dateFormatter.dateFormat = "yyy"
          return dateFormatter.string(from: dateFromString)
      }
      return nil
  }
  
  func posterImageUrl() -> String? {
    return "\(MovieServiceEndPoint.POSTER_BASE_URL.rawValue)\(posterPath ?? "")"
  }
  func bigPosterImageUrl() -> String? {
    return "\(MovieServiceEndPoint.BIG_POSTER_BASE_URL.rawValue)\(posterPath ?? "")"
    
  }
}
