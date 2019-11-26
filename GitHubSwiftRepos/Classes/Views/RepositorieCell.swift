//
//  RepositorieCell.swift
//  GitHubSwiftRepos
//
//  Created by Bruno Fonseca de Almeida on 25/11/19.
//  Copyright © 2019 Bruno Fonseca de Almeida. All rights reserved.
//

import UIKit

class RepositorieCell: UITableViewCell {
  @IBOutlet var repositorio: UILabel!
  @IBOutlet var userName: UILabel!
  @IBOutlet var starsCount: UILabel!
  @IBOutlet var avatar: UIImageView!
  @IBOutlet var indicatorView: UIActivityIndicatorView!
  let RWGreen = UIColor(red: CGFloat(0), green: CGFloat(104/255.0), blue: CGFloat(55/255.0), alpha: CGFloat(1.0))

  override func prepareForReuse() {
    super.prepareForReuse()
    
    configure(with: .none)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    indicatorView.hidesWhenStopped = true
    indicatorView.color = RWGreen
  }
  
  func configure(with repositorie: [String: Any]?) {
    if let repositorie = repositorie {
      repositorio?.text = repositorie["name"] as? String
      let owner = repositorie["owner"] as? [String: Any]
      userName?.text = owner?["login"] as? String
      starsCount?.text = "\((repositorie["stargazers_count"] as? Int)!) Stars"
      avatar.load(url: URL(string: (owner?["avatar_url"] as? String)!)!)
      repositorio.alpha = 1
      userName.alpha = 1
      starsCount.alpha = 1
      avatar.alpha = 1
      indicatorView.stopAnimating()
    } else {
      repositorio.alpha = 0
      userName.alpha = 0
      starsCount.alpha = 0
      avatar.alpha = 0
      indicatorView.startAnimating()
    }
  }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
