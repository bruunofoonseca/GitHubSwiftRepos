//
//  ViewModel.swift
//  GitHubSwiftRepos
//
//  Created by Bruno Fonseca de Almeida on 22/11/19.
//  Copyright © 2019 Bruno Fonseca de Almeida. All rights reserved.
//

import UIKit

protocol ViewModelDelegate: class {
  func onRequestCompleted()
  func onRequestFailed(with reason: String)
}

final class ViewModel: NSObject {
  private weak var delegate: ViewModelDelegate?

  private var repositories : [[String: Any]]! = [[:]]
  private var currentPage = 1
  private var total = 0
  private var isRequestInProgress = false

  init(delegate: ViewModelDelegate) {
    self.repositories.removeAll()
    self.delegate = delegate
  }

  var totalCount: Int {
    return total
  }

  var currentCount: Int {
    return repositories.count
  }

  func repositorie(at index: Int) -> [String: Any] {
    return repositories[index]
  }

  func getRepos() {
    guard !isRequestInProgress else {
      return
    }

    isRequestInProgress = true

    APIManager.sharedInstance.getSwiftRepositories(page: currentPage, onSuccess:
      { json in
        DispatchQueue.main.async {
          print(json)
          self.currentPage += 1
          self.isRequestInProgress = false

          let newRepositories = (json.dictionaryObject!["items"] as? [[String : Any]])!
          self.repositories.append(contentsOf: newRepositories)
          self.total += self.repositories.count

          self.delegate?.onRequestCompleted()
        }
       }, onFailure: { error in
         DispatchQueue.main.async {
           self.isRequestInProgress = false
           self.delegate?.onRequestFailed(with: error.localizedDescription)
         }
       })
  }
}
