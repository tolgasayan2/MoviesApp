//
//  MovieService.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 15.06.2022.
//

import Foundation
import Alamofire


enum MovieServiceEndPoint: String{
  case VIDEOS = "/videos?"
  case CREDITS = "/credits?"
  case BASE_URL = "https://api.themoviedb.org/3/movie/"
  case PATH = "popular?"
  case API_KEY = "api_key=98fc64f362340d901cd5f462cd7d1912"
  case POSTER_BASE_URL = "https://image.tmdb.org/t/p/w185"
  case BIG_POSTER_BASE_URL = "https://image.tmdb.org/t/p/w500"
  case PAGE = "page="
  case AND = "&"
  
  static func Path() -> String {
    return "\(BASE_URL.rawValue)\(PATH.rawValue)\(API_KEY.rawValue)"
  }
  static func videosPath(id: Int) -> String {
    return "\(BASE_URL.rawValue)\(String(id))\(VIDEOS.rawValue)\(API_KEY.rawValue)"
  }
  static func creditsPath(id: Int) -> String {
    return "\(BASE_URL.rawValue)\(String(id))\(CREDITS.rawValue)\(API_KEY.rawValue)"
  }
  static func popularPath(page: Int) -> String {
    return "\(BASE_URL.rawValue)\(PATH.rawValue)\(PAGE.rawValue)\(String(page))\(AND.rawValue)\(API_KEY.rawValue)"
  }
}

protocol IMovieService {
  func fetchPopularMovies(page: Int,pagination: Bool,response: @escaping ([Result]?) -> Void)
  func fetchVideos(pagination: Bool,response: @escaping ([VideoResult]?) -> Void)
  func fetchCast(pagination: Bool,response: @escaping ([CastResult]?) -> Void)
  var id: Int { get set }
  var isPaginating: Bool { get }
}

class MovieService: IMovieService {
  var isPaginating = false
  var id: Int = 0
  
   func fetchCast(pagination: Bool = false, response: @escaping ([CastResult]?) -> Void) {
    AF.request(MovieServiceEndPoint.creditsPath(id: id)).responseDecodable(of: Cast.self) { (model) in
      if pagination {
        self.isPaginating = true
      }
      guard let data = model.value else {
        response(nil)
        return
      }
      response(data.cast)
    }
  }
  
   func fetchVideos(pagination: Bool = false,response: @escaping ([VideoResult]?) -> Void) {
    AF.request(MovieServiceEndPoint.videosPath(id: id)).responseDecodable(of: Video.self) { (model) in
      if pagination {
        self.isPaginating = true
      }
      guard let data = model.value else {
        response(nil)
        return
      }
      response(data.results)
    }

  }
  
  func fetchPopularMovies(page: Int,pagination: Bool,response: @escaping ([Result]?) -> Void) {
     AF.request(MovieServiceEndPoint.popularPath(page: page)).responseDecodable(of: User.self) { (model) in
      if pagination {
        self.isPaginating = true
      }
       guard let data = model.value else {
        response(nil)
        return
      }
       response(data.results)
    }
  }
}
