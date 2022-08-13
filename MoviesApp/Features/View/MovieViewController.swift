//
//  ViewController.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 15.06.2022.
//

import UIKit
import SnapKit

protocol MovieOutput {
  func changeLoading(isLoad: Bool)
  func saveDatas(values: [Result])
}

final class MovieViewController: UIViewController {
  
  private var searchBar: UISearchBar = UISearchBar()
  private let tableView: UITableView = UITableView()
  private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
  var results: [Result] = []
  var searchResults: [Result] = []
  var isFiltered: Bool = false
  var page: Int = 1
  lazy var viewModel: IMovieViewModel = MovieViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    viewModel.delegate(output: self)
    viewModel.fetchPopularItems(page: self.page)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.left.right.equalToSuperview()
    }
  }
  
  func configure() {
    title = "Popular Movies"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
    navigationItem.setRightBarButton(UIBarButtonItem(customView: indicator), animated: true)
    navigationController?.navigationBar.tintColor = .placeholderText
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
    searchBar.searchBarStyle = UISearchBar.Style.minimal
    searchBar.placeholder = " Search..."
    UISearchBar.appearance().tintColor = UIColor.systemOrange
    searchBar.delegate = self
    tableView.tableHeaderView = searchBar
    navigationItem.backButtonTitle = ""
    tableView.rowHeight = 100
    view.backgroundColor = UIColor.systemBackground
    tableView.backgroundColor = .systemBackground
    MovieTableViewCell.Register.register(tableView: tableView)
    tableView.delegate = self
    tableView.dataSource = self
    indicator.color = .systemOrange
    indicator.startAnimating()
  }
}

// MARK: UITableView Delegate & DataSource
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchBar.searchTextField.text!.isEmpty ? results.count : searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.Identifier.custom.rawValue, for: indexPath) as? MovieTableViewCell else {
      return UITableViewCell()
    }
    
    if isFiltered {
      cell.selectionStyle = .none
      cell.accessoryType = .disclosureIndicator
      cell.saveModel(model: searchResults[indexPath.row])
    } else {
      cell.selectionStyle = .none
      cell.accessoryType = .disclosureIndicator
      cell.saveModel(model: results[indexPath.row])
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    navigateToDetailsViewController(indexPath: indexPath)
  }
  
  func navigateToDetailsViewController (indexPath: IndexPath) {
    let detailController = MovieDetailsViewController()
    if isFiltered {
      detailController.movie = self.searchResults[indexPath.row]
      detailController.id = self.searchResults[indexPath.row].id
    } else {
      detailController.movie = self.results[indexPath.row]
      detailController.id = self.results[indexPath.row].id
    }
    self.navigationController!.pushViewController(detailController, animated: true)
  }
}

// MARK: UISearchBar delegate implentations
extension MovieViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    isFiltered = true
    searchResults =  searchText.isEmpty ? results : results.filter { (movie) -> Bool in
      return movie.title.range(of: searchText , options: .caseInsensitive) != nil
    }
    tableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchResults = results
    searchBar.resignFirstResponder()
    isFiltered = false
    tableView.reloadData()
  }
 
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if !isFiltered {
      let position = scrollView.contentOffset.y
      if position > (tableView.contentSize.height - 50 - scrollView.frame.size.height) {
        guard viewModel.movieService.isPaginating else {
          return
        }
        changeLoading(isLoad: true)
        viewModel.movieService.fetchPopularMovies(page: page + 1, pagination: true) { [weak self] result in
          
          DispatchQueue.main.async {

            self?.results.append(contentsOf: result ?? [])
            self?.tableView.reloadData()
            self?.changeLoading(isLoad: false)
          }
        }
        page += 1
      }
    }
  }
  
}

extension MovieViewController: MovieOutput {
 
  func changeLoading(isLoad: Bool) {
    isLoad ? indicator.startAnimating() : indicator.stopAnimating()
  }
  
  func saveDatas(values: [Result]) {
    results = values
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

