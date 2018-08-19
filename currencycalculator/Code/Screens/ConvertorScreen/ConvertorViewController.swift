//
//  ConvertorViewController.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

class ConvertorViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView? {
        didSet {
            setupTableView()
        }
    }
    
    var viewModel: ConvertorViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
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
        tableView?.register(UINib(nibName: "EditCurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: .cellReuseIdentifier)
        tableView?.dataSource = self
        tableView?.delegate = self
    
    }
    
    private func updateTable() {
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        tableView?.reloadSections(.secondSection, with: UITableViewRowAnimation.none)
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    private func changeEditingState() {
        tableView?.reloadSections(.firstSection, with: UITableViewRowAnimation.automatic)
        if viewModel.isEditing {
        tableView?.cellForRow(at: .firstRow)?.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        tableView?.contentInset.bottom = keyboardFrame.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView?.contentInset.bottom = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
       NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

extension ConvertorViewController: UITableViewDataSource {
    
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
        
        switch indexPath {
        case .firstRow:
            rate = viewModel.rates[0]
        default:
            rate = viewModel.rates[indexPath.row + 1]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellReuseIdentifier) as? EditCurrencyTableViewCell ?? EditCurrencyTableViewCell()
        
        cell.configure(currency: rate.currency, description: rate.description, value: rate.value,
            fieldEditedClosure: {
                newValue in
                
                self.viewModel.baseValue = Decimal(string: newValue ?? "0") ?? 0
            }
        )
        
        return cell
    }
}

extension ConvertorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == .secondSection, let currency = viewModel?.rates[indexPath.row + 1].currency else {
            viewModel.isEditing = !viewModel.isEditing
            return
        }
        
        tableView.scrollToRow(at: .firstRow, at: UITableViewScrollPosition.top, animated: false)
        tableView.cellForRow(at: .firstRow)?.resignFirstResponder()
        
        tableView.beginUpdates()
        tableView.moveRow(at: indexPath, to: .firstRow)
        tableView.moveRow(at: .firstRow, to: .secondRow)
        tableView.endUpdates()
        viewModel.baseCurrency = currency
        viewModel.isEditing = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
}

private extension Int {
    static let secondSection = 1
}

private extension IndexSet {
    static let firstSection = IndexSet(integer: 0)
    static let secondSection = IndexSet(integer: 1)
}

private extension IndexPath {
    static let firstRow = IndexPath(row: 0, section: 0)
    static let secondRow = IndexPath(row: 0, section: 1)
}

private extension String {
    static let cellReuseIdentifier = "cell"
}
