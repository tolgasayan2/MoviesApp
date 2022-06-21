//
//  CastTableViewCell.swift
//  MoviesApp
//
//  Created by Tolga Sayan on 20.06.2022.
//

import UIKit
import SnapKit
import AlamofireImage

class CastTableViewCell: UITableViewCell {

  private let personImageView: UIImageView = UIImageView()
  private let nameLabel: UILabel = UILabel()
  private let characterLabel: UILabel = UILabel()
  
  enum Identifier: String {
    case custom = "cast"
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    characterLabel.font = UIFont.italicSystemFont(ofSize: 15)
    nameLabel.numberOfLines = 0
    personImageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(personImageView)
    addSubview(nameLabel)
    addSubview(characterLabel)
    personImageView.contentMode = .scaleAspectFit
    
    personImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.bottom.equalToSuperview().offset(-10)
      make.left.equalToSuperview().offset(10)
      make.right.equalTo(personImageView.snp.left).offset(50)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(personImageView.snp.top)
      make.right.equalToSuperview()
      make.left.equalTo(personImageView.snp.right).offset(20)
      
    }
    
    characterLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom)
      make.right.left.equalTo(nameLabel)
      make.bottom.equalTo(personImageView.snp.bottom)
    }
  }
  
  func saveModel(model: CastResult) {
    nameLabel.text = model.originalName
    characterLabel.text = model.character
    personImageView.af.setImage(withURL: URL(string: model.bigPosterImageUrl()!)! ,placeholderImage: UIImage(named: "default-profile"), progressQueue: .main, imageTransition: .crossDissolve(1.0))
  }
  
}
