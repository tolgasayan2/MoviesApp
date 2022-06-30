//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 16.06.2022.
//

import UIKit
import SnapKit
import AlamofireImage

protocol VideoOutput {
  func changeLoading(isLoad: Bool)
  func saveVideos(values: [VideoResult])
}

final class MovieDetailsViewController: UIViewController {
  var results: [VideoResult] = []
  var id: Int!
  var movie: Result!
  lazy var viewModel: IMovieViewModel = MovieViewModel()
  
  private let posterImageView: UIImageView = UIImageView()
  private let summaryLabel: UILabel = UILabel()
  private let ratingLabel: UILabel = UILabel()
  private let summaryTextLabel: UILabel = UILabel()
  private let castButton: UIButton = UIButton()
  private let scrollView: UIScrollView = UIScrollView()
  private let contentView: UIView = UIView()
  private let trailerLabel: UILabel = UILabel()
  private let tableView: UITableView = UITableView()
  private let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    configure()
    viewModel.videoDelegate(output: self)
    viewModel.fetchVideoItems(id: id)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.addSubview(posterImageView)
    contentView.addSubview(summaryLabel)
    contentView.addSubview(ratingLabel)
    contentView.addSubview(castButton)
    contentView.addSubview(summaryTextLabel)
    contentView.addSubview(trailerLabel)
    scrollView.addSubview(castButton)
    scrollView.addSubview(tableView)
    scrollView.contentSize = CGSize(width: view.frame.width, height: 1300)
    scrollView.addSubview(contentView)
    view.addSubview(scrollView)
    
    posterImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      make.bottom.equalTo(posterImageView.snp.top).offset(550)
    }
    
    ratingLabel.snp.makeConstraints { make in
      make.top.equalTo(posterImageView.snp.bottom).offset(20)
      make.left.equalTo(posterImageView.snp.left).offset(20)
      make.right.equalTo(posterImageView.snp.right).offset(-20)
      make.bottom.equalTo(ratingLabel.snp.top).offset(35)
    }
    
    summaryLabel.snp.makeConstraints { make in
      make.top.equalTo(ratingLabel.snp.bottom).offset(10)
      make.right.equalTo(ratingLabel.snp.right)
      make.left.equalTo(ratingLabel.snp.left)
      make.bottom.equalTo(summaryLabel.snp.top).offset(35)
    }
    
    summaryTextLabel.snp.makeConstraints { make in
      make.top.equalTo(summaryLabel.snp.bottom).offset(10)
      make.right.equalTo(summaryLabel.snp.right)
      make.left.equalTo(summaryLabel.snp.left)
      make.bottom.equalTo(trailerLabel.snp.top).offset(-10)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
      make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    
    contentView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.snp.top)
      make.left.equalTo(scrollView.snp.left)
      make.right.equalTo(scrollView.snp.right)
      make.bottom.equalTo(scrollView.snp.bottom)
    }
    
    trailerLabel.snp.makeConstraints { make in
      make.top.equalTo(summaryTextLabel.snp.bottom).offset(10)
      make.right.equalTo(summaryTextLabel.snp.right)
      make.left.equalTo(summaryTextLabel.snp.left)
      make.bottom.equalTo(trailerLabel.snp.top).offset(35)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(trailerLabel.snp.bottom).offset(10)
      make.right.equalTo(trailerLabel.snp.right)
      make.left.equalTo(trailerLabel.snp.left).offset(-20)
      make.bottom.equalTo(tableView.snp.top).offset(230)
    }
    
    castButton.snp.makeConstraints { make in
      make.top.equalTo(tableView.snp.bottom).offset(25)
      make.right.equalTo(castButton.snp.left).offset(140)
      make.centerX.equalTo(self.view)
      make.bottom.equalTo(castButton.snp.top).offset(50)
    }
  }
  
  func configure() {
    title = movie.title
    id = movie.id
    navigationItem.setRightBarButton(UIBarButtonItem(customView: indicator), animated: true)
    indicator.color = .systemOrange
    view.backgroundColor = .systemBackground
    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.translatesAutoresizingMaskIntoConstraints = true
    ratingLabel.translatesAutoresizingMaskIntoConstraints = false
    summaryLabel.translatesAutoresizingMaskIntoConstraints = false
    summaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    posterImageView.af.setImage(withURL: URL(string: movie.bigPosterImageUrl()!)! ,placeholderImage: UIImage(named: "default"), progressQueue: .main, imageTransition: .crossDissolve(0.5))
    posterImageView.clipsToBounds = true
    posterImageView.contentMode = .scaleAspectFill
    posterImageView.sizeToFit()
    ratingLabel.sizeToFit()
    ratingLabel.text = "⭐️ \(String(movie.voteAverage))"
    ratingLabel.textColor = .systemOrange
    ratingLabel.textAlignment = .center
    ratingLabel.shadowColor = .black
    summaryLabel.font = .systemFont(ofSize: 23, weight: .regular)
    summaryLabel.textColor = .systemOrange
    summaryLabel.attributedText = NSAttributedString(string: "Overview", attributes:
                                                      [.underlineStyle: NSUnderlineStyle.single.rawValue])
    summaryTextLabel.text = movie.overview
    summaryTextLabel.font = .systemFont(ofSize: 17, weight: .medium)
    summaryTextLabel.numberOfLines = 0
    summaryTextLabel.lineBreakMode = .byTruncatingTail
    summaryLabel.sizeToFit()
    summaryTextLabel.sizeToFit()
    trailerLabel.textColor = .systemOrange
    trailerLabel.font = .systemFont(ofSize: 23, weight: .regular)
    trailerLabel.attributedText = NSAttributedString(string: "Watch On YouTube🍿", attributes:
                                                      [.underlineStyle: NSUnderlineStyle.single.rawValue])
    castButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
    castButton.isUserInteractionEnabled = true
    castButton.setTitle("Actors", for: .normal)
    castButton.layer.cornerRadius = 12
    castButton.setTitleColor(.orange, for: .normal)
    castButton.layer.borderWidth = 1.5
    castButton.layer.borderColor = UIColor.systemOrange.cgColor
    castButton.backgroundColor = .systemBackground
    castButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    castButton.layer.shadowOffset = CGSize(width: 3.0, height: 4.0)
    castButton.layer.shadowOpacity = 1.0
    castButton.layer.shadowRadius = 1.0
    castButton.layer.masksToBounds = false
    scrollView.isDirectionalLockEnabled = true
    scrollView.alwaysBounceVertical = true
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    tableView.indicatorStyle = .black
    tableView.delegate = self
    tableView.dataSource = self
    scrollView.delegate = self
    
  }
  
  @objc func pressed() {
    navigateToDetailsViewController()
  }
  
  func navigateToDetailsViewController () {
    let castController = CastViewController()
    castController.id = id
    self.navigationController!.pushViewController(castController, animated: true)
  }
}
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = results[indexPath.row].name
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.goToYoutube(key: results[indexPath.row].key)
  }
}

extension MovieDetailsViewController: VideoOutput {
  func changeLoading(isLoad: Bool) {
        isLoad ? indicator.startAnimating() : indicator.stopAnimating()
  }
  
  func saveVideos(values: [VideoResult]) {
    results = values
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
