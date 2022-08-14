//
//  MovieViewModel.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 15.06.2022.
//

import Foundation
import UIKit

protocol IMovieViewModel {
  func fetchPopularItems(page: Int)
  func fetchVideoItems(id: Int)
  func fetchCastItems(id: Int)
  func fetchSearchItems(query: String)
  func goToYoutube(key: String?)
  func changeLoading()
  func delegate(output: MovieOutput)
  func videoDelegate(output: VideoOutput)
  func castDelegate(output: CastOutput)
  
  var movies: [Result] { get set }
  var videos: [VideoResult] { get set }
  var casts: [CastResult] { get set }
  var movieService: IMovieService { get }
  var movieOutput: MovieOutput? { get }
  var videoOutput: VideoOutput? { get }
  var castOutput: CastOutput? { get }
}

class MovieViewModel: IMovieViewModel {
  
  var castOutput: CastOutput?
  var movieOutput: MovieOutput?
  var videoOutput: VideoOutput?
  var isLoading = false
  var movies: [Result] = []
  var videos: [VideoResult] = []
  var casts: [CastResult] = []
  var movieService: IMovieService
  
  init() {
    movieService = MovieService()
  }
  
  func fetchPopularItems(page: Int) {
    changeLoading()
    movieService.fetchPopularMovies(page: page, pagination: true) { [weak self] response in
      self?.changeLoading()
      self?.movies = response ?? []
      self?.movieOutput?.saveDatas(values: self?.movies ?? [])
    }
  }
  
  func fetchVideoItems(id: Int) {
    changeLoading()
    movieService.id = id
    movieService.fetchVideos(pagination: true) { [weak self] result in
      self?.changeLoading()
      self?.videos = result ?? []
      self?.videoOutput?.saveVideos(values: self?.videos ?? [])
    }
  }
  
  func fetchCastItems(id: Int) {
    changeLoading()
    movieService.id = id
    movieService.fetchCast(pagination: true) { [weak self] response in
      self?.changeLoading()
      self?.casts = response ?? []
      self?.castOutput?.saveCast(values: self?.casts ?? [])
    }
      
  }
  
  func fetchSearchItems(query: String) {
    changeLoading()
    movieService.fetchSearch(query: query, pagination: true) { [weak self] response in
      self?.changeLoading()
      self?.movies = response ?? []
      self?.movieOutput?.saveDatas(values: self?.movies ?? [])
    }
    
  }
  
  func goToYoutube(key: String?) {
      if let trailerKey = key {
          var url = URL(string:"youtube://\(trailerKey)")!
          if !UIApplication.shared.canOpenURL(url)  {
              url = URL(string:"http://www.youtube.com/watch?v=\(trailerKey)")!
          }
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
  }
  
  func changeLoading() {
    isLoading = !isLoading
    movieOutput?.changeLoading(isLoad: isLoading)
    videoOutput?.changeLoading(isLoad: isLoading)
    castOutput?.changeLoading(isLoad: isLoading)
  }
  
  func delegate(output: MovieOutput) {
    movieOutput = output
  }
  
  func videoDelegate(output: VideoOutput) {
    videoOutput = output
  }
  
  func castDelegate(output: CastOutput) {
    castOutput = output
  }
  
}
