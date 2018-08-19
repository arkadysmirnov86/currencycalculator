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
        tableView?.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
        tableView?.cellForRow(at: IndexPath(row: 0, section: 0))?.becomeFirstResponder()
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
        default:
            rate = viewModel.rates[indexPath.row + 1]
        }
        let editCell = tableView.dequeueReusableCell(withIdentifier: .editCellReuseIdentifier) as? EditCurrencyTableViewCell ?? EditCurrencyTableViewCell()
        editCell.configure(currency: rate.currency, description: "here should be desciption ", value: rate.value,
            fieldEditedClosure: {
                newValue in
                
                self.viewModel.baseValue = Decimal.init(string: newValue ?? "0") ?? 0
            }
        )
        cell = editCell
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.resignFirstResponder()
        
        if indexPath.section == 1, let currency = viewModel?.rates[indexPath.row + 1].currency {
            tableView.beginUpdates()
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
            tableView.endUpdates()
            viewModel.baseCurrency = currency
        }
        
        viewModel.isEditing = true
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
    }
}

private extension String {
    static let cellReuseIdentifier = "cell"
    static let editCellReuseIdentifier = "editcell"
}
