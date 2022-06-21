//
//  Cast.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 19.06.2022.
//

import Foundation
struct Cast: Codable {
  let id: Int
  let cast: [CastResult]
}

// MARK: - Cast
struct CastResult: Codable {
  let adult: Bool
  let gender: Int?
  let id: Int
  let knownForDepartment, name, originalName: String
  let popularity: Double
  let profilePath: String?
  let castID: Int
  let character, creditID: String
  let order: Int
  
  enum CodingKeys: String, CodingKey {
    case adult, gender, id
    case knownForDepartment = "known_for_department"
    case name
    case originalName = "original_name"
    case popularity
    case profilePath = "profile_path"
    case castID = "cast_id"
    case character
    case creditID = "credit_id"
    case order
  }
  
  func bigPosterImageUrl() -> String? {
    return "\(MovieServiceEndPoint.BIG_POSTER_BASE_URL.rawValue)\(profilePath ?? "")"
  }
}
