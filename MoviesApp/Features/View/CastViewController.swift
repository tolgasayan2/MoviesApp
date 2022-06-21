//
//  CastViewController.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 20.06.2022.
//

import UIKit
import SnapKit
import Alamofire

protocol CastOutput {
  func changeLoading(isLoad: Bool)
  func saveCast(values: [CastResult])
}

final class CastViewController: UIViewController {
  var id: Int!
  var results: [CastResult] = []
  private let tableView: UITableView = UITableView()
  private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
  lazy var viewModel: IMovieViewModel = MovieViewModel()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    configure()
    viewModel.castDelegate(output: self)
    viewModel.fetchCastItems(id: id)
   
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
    title = "Actors"
   navigationItem.setRightBarButton(UIBarButtonItem(customView: indicator), animated: true)
   indicator.color = .orange
   tableView.rowHeight = 100
   view.backgroundColor = .white
   tableView.backgroundColor = .white
   tableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.Identifier.custom.rawValue)
   tableView.delegate = self
   tableView.dataSource = self
  }
}

extension CastViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: CastTableViewCell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.Identifier.custom.rawValue, for: indexPath) as? CastTableViewCell else {
      return UITableViewCell()
    }
    cell.selectionStyle = .none
    cell.saveModel(model: results[indexPath.row])

    return cell
  }
}

extension CastViewController: CastOutput {
  func changeLoading(isLoad: Bool) {
    isLoad ? indicator.startAnimating() : indicator.stopAnimating()
  }
  
  func saveCast(values: [CastResult]) {
    results = values
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
