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
        tableView?.delegate = self
    
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currency = viewModel?.rates[indexPath.row].currency {
            tableView.beginUpdates()
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            tableView.cellForRow(at: indexPath)?.isSelected = false
            viewModel?.baseCurrency = currency
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
        
    }
}

private extension String {
    static let cellReuseIdentifier = "cell"
}
