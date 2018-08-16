//
//  EditCurrencyTableViewCell.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/16/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

class EditCurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyImageView: UIImageView! {
        didSet {
            currencyImageView.backgroundColor = .gray
            currencyImageView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rateTextField: UITextField! {
        didSet {
            rateTextField.addTarget(self, action: #selector(rateTextFieldDidChangeValue), for: UIControlEvents.editingChanged)
        }
    }

    var fieldEditedClosure: ((String?) -> Void)?
    
    func configure(currency: String, value: String, fieldEditedClosure: @escaping (String?) -> Void) {
        currencyLabel.text = currency
        rateTextField.text = value
        self.fieldEditedClosure = fieldEditedClosure
    }
    
    @objc private func rateTextFieldDidChangeValue(_ textField: UITextField) {
        fieldEditedClosure?(textField.text)
    }
}
