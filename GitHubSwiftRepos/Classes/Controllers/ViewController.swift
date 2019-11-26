//
//  ViewController.swift
//  GitHubSwiftRepos
//
//  Created by Bruno Fonseca de Almeida on 19/11/19.
//  Copyright © 2019 Bruno Fonseca de Almeida. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AlertDisplayer {
  @IBOutlet var indicatorView: UIActivityIndicatorView!
  @IBOutlet var tableView: UITableView!

  let RWGreen = UIColor(red: CGFloat(0), green: CGFloat(104/255.0), blue: CGFloat(55/255.0), alpha: CGFloat(1.0))
  private var viewModel: ViewModel!
  private var shouldShowLoadingCell = false

  override func viewDidLoad() {
    super.viewDidLoad()

    indicatorView.color = RWGreen
    indicatorView.startAnimating()

    tableView.isHidden = true
    tableView.separatorColor = RWGreen
    tableView.dataSource = self

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
    tableView.refreshControl = refreshControl

    viewModel = ViewModel(delegate: self)

    viewModel.getRepos()
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.totalCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RepositorieCell

    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    } else {
      cell.configure(with: viewModel.repositorie(at: indexPath.row))
    }

    return cell
  }
}

extension ViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      viewModel.getRepos()
    }
  }
}

extension ViewController: ViewModelDelegate {
  func onRequestCompleted() {
    indicatorView.stopAnimating()
    tableView.isHidden = false
    tableView.reloadData()
  }

  func onRequestFailed(with reason: String) {
    indicatorView.stopAnimating()

    let title = "Warning"
    let action = UIAlertAction(title: "OK", style: .default)
    displayAlert(with: title , message: reason, actions: [action])
  }
}

private extension ViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }

  @objc func refresh() {
    viewModel.getRepos()
    tableView.refreshControl?.endRefreshing()
  }
}
