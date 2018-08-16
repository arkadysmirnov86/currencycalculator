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
    
    var viewModel: ViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        viewModel?.ratesChanged = {
            [weak self] in
            
            self?.updateTable()
        }
        viewModel?.isEditingChanged = {
            [weak self] in
            
            self?.changeEditingState()
        }
    }
    
    private func setupTableView() {
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: .cellReuseIdentifier)
        tableView?.register(UINib(nibName: "EditCurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: .editCellReuseIdentifier)
        tableView?.dataSource = self
        tableView?.delegate = self
    
    }
    
    private func updateTable() {
        tableView?.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.automatic)
    }
    
    private func changeEditingState() {
        tableView?.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.automatic)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return (viewModel?.rates.count ?? 0) - 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rate: RateModel
        let cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            rate = viewModel.rates[0]
            if viewModel.isEditing {
                let editCell = tableView.dequeueReusableCell(withIdentifier: .editCellReuseIdentifier) as? EditCurrencyTableViewCell ?? EditCurrencyTableViewCell()
                editCell.configure(currency: rate.currency, value: "\(rate.value)",
                    fieldEditedClosure: {
                        newValue in
                        
                        self.viewModel.baseValue = Decimal.init(string: newValue ?? "0") ?? 0
                    }
                )
                cell = editCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: .cellReuseIdentifier) ?? UITableViewCell()
                cell.textLabel?.text = "\(rate.currency) \(rate.value)"
            }
        default:
            rate = viewModel.rates[indexPath.row + 1]
            cell = tableView.dequeueReusableCell(withIdentifier: .cellReuseIdentifier) ?? UITableViewCell()
            cell.textLabel?.text = "\(rate.currency) \(rate.value)"
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currency = viewModel?.rates[indexPath.row].currency {
            tableView.beginUpdates()
            tableView.cellForRow(at: indexPath)?.isSelected = false
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
            viewModel?.baseCurrency = currency
            viewModel?.isEditing = true
            tableView.endUpdates()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
        
    }
}



private extension String {
    static let cellReuseIdentifier = "cell"
    static let editCellReuseIdentifier = "editcell"
    
}
