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
            currencyImageView.layer.cornerRadius = 25
            currencyImageView.layer.borderColor = UIColor.black.cgColor
            currencyImageView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rateTextField: UITextField! {
        didSet {
            rateTextField.addTarget(self, action: #selector(rateTextFieldDidChangeValue), for: UIControlEvents.editingChanged)
        }
    }
    @IBOutlet weak var rateLabel: UILabel!
    //REMARK: you could use layers for underline drawing instead this view and constraints
    @IBOutlet weak var underlineView: UIView!

    var fieldEditedClosure: ((String?) -> Void)?
    
    func configure(currency: String, description: String, value: Decimal, fieldEditedClosure: @escaping (String?) -> Void) {
        currencyLabel.text = currency
        descriptionLabel.text = description
        
        //TODO: specify rounding and formating rules
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        let rateString = formatter.string(from: value as NSDecimalNumber)
        rateTextField.text = rateString
        rateLabel.text = rateString
        
        self.fieldEditedClosure = fieldEditedClosure
        self.selectionStyle = .none
        
        //TODO: Here should be loading image from resources by currency key:
        //      currencyImageView.#imageLiteral(resourceName: "\(flag_\(currency))")
        //  or from particular endpoint (you could you https://github.com/onevcat/Kingfisher for that):
        //      currencyImageView.kf.setImage(URL("somestring"))
        //  or just loading Data(url: url) on separate queue.
    }
    
    @objc private func rateTextFieldDidChangeValue(_ textField: UITextField) {
        rateLabel.text = textField.text
        fieldEditedClosure?(textField.text)
    }
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        rateTextField.isHidden = false
        rateLabel.isHidden = true
        underlineView.backgroundColor = UIColor.blue
        return rateTextField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        rateTextField.isHidden = true
        rateLabel.isHidden = false
        underlineView.backgroundColor = .lightGray
        return rateTextField.resignFirstResponder()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        underlineView.backgroundColor = .lightGray
        rateLabel.isHidden = false
        rateTextField.isHidden = true
    }
    
    @objc private func doneTapped() {
        resignFirstResponder()
    }
}
