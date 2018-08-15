//
//  ViewController.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView? {
        didSet {
            setupTableView()
        }
    }
    
    var viewModel: ViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        viewModel?.ratesChanged = {
            [weak self] in
            
            self?.updateTable()
        }
    }
    
    private func setupTableView() {
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: .cellReuseIdentifier)
        tableView?.dataSource = self
    
    }
    
    private func updateTable() {
        tableView?.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellReuseIdentifier) ?? UITableViewCell()
        let rate = viewModel?.rates[indexPath.row]
        cell.textLabel?.text = "\(rate?.currency ?? "") \(rate?.value ?? 0)"
        return cell
    }
}

private extension String {
    static let cellReuseIdentifier = "cell"
}
