//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 16.06.2022.
//

import UIKit
import SnapKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell {
  
  private let posterImageView: UIImageView = UIImageView()
  private let titleLabel: UILabel = UILabel()
  private let releaseDateLabel: UILabel = UILabel()
  
  enum Identifier: String {
    case custom = "movie"
  }
  

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    releaseDateLabel.font = UIFont.italicSystemFont(ofSize: 15)
    titleLabel.numberOfLines = 0
    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(posterImageView)
    addSubview(titleLabel)
    addSubview(releaseDateLabel)
    posterImageView.contentMode = .scaleAspectFit
    
    posterImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.bottom.equalToSuperview().offset(-10)
      make.left.equalToSuperview().offset(10)
      make.right.equalTo(posterImageView.snp.left).offset(50)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(posterImageView.snp.top)
      make.right.equalToSuperview()
      make.left.equalTo(posterImageView.snp.right).offset(20)
      
    }
    
    releaseDateLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
      make.right.left.equalTo(titleLabel)
      make.bottom.equalTo(posterImageView.snp.bottom)
    }
  }
  func saveModel(model: Result) {
    titleLabel.text = model.title
    releaseDateLabel.text = model.relaseYear()
    posterImageView.af.setImage(withURL: URL(string: model.posterImageUrl()!)! ,placeholderImage: UIImage(named: "default"), progressQueue: .main, imageTransition: .crossDissolve(0.5))
  }
}

