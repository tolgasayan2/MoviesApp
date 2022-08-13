//
//  SearchViewController.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 8.08.2022.
//

import UIKit
import SnapKit


class SearchViewController: UIViewController {
  private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
  private var searchBar: UISearchController = {
    let sb = UISearchController()
    sb.searchBar.placeholder = "Search Movies..."
    sb.searchBar.searchBarStyle = .minimal
    sb.searchBar.sizeToFit()
    sb.searchBar.isTranslucent = false
    sb.searchBar.backgroundColor = .systemBackground
    return sb
  }()
  private let tableView: UITableView = UITableView()
  var results: [Result] = []
  lazy var viewModel: IMovieViewModel = MovieViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    viewModel.fetchPopularItems(page: 2)
    viewModel.delegate(output: self)
    
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
    navigationItem.title = "Movie Search"
    view.backgroundColor = .systemBackground
    tableView.delegate = self
    tableView.dataSource = self
    indicator.color = .systemOrange
    indicator.startAnimating()
    searchBar.searchResultsUpdater = self
    navigationItem.searchController = searchBar
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
    navigationItem.setRightBarButton(UIBarButtonItem(customView: indicator), animated: true)
    navigationController?.navigationBar.tintColor = .placeholderText
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
    MovieTableViewCell.Register.register(tableView: tableView)
    tableView.rowHeight = 100
  }
  
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.Identifier.custom.rawValue, for: indexPath) as? MovieTableViewCell else {
      return UITableViewCell()
    }
    cell.saveModel(model: results[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    navigateToDetailsViewController(indexPath: indexPath)
  }
  
  func navigateToDetailsViewController (indexPath: IndexPath) {
    let detailController = MovieDetailsViewController()
      detailController.movie = self.results[indexPath.row]
      detailController.id = self.results[indexPath.row].id
    self.navigationController!.pushViewController(detailController, animated: true)
  }
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else { return }
  }
  
  
}

extension SearchViewController: MovieOutput {
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
