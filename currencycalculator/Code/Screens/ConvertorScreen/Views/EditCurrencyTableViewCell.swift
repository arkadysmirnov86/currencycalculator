//
//  EditCurrencyTableViewCell.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/16/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

class EditCurrencyTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 82.0
    
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
            rateTextField.addTarget(self, action: #selector(rateTextFieldEditingChanged), for: UIControlEvents.editingChanged)
        }
    }
    @IBOutlet weak var rateLabel: UILabel!
    //REMARK: you could use layers for underline drawing instead this view and constraints
    @IBOutlet weak var underlineView: UIView!

    var fieldEditedClosure: ((String?) -> Void)?
    
    func configure(currency: String, description: String, value: Decimal, fieldEditedClosure: @escaping (String?) -> Void) {
        currencyLabel.text = currency
        descriptionLabel.text = description
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = .maximumFractionDigits
        formatter.roundingMode = .halfEven
        let rateString = formatter.string(from: value as NSDecimalNumber)
        rateTextField.text = rateString
        rateLabel.text = rateString
        
        self.fieldEditedClosure = fieldEditedClosure
        selectionStyle = .none
        
        loadImage(for: currency)
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
    
    @objc private func rateTextFieldEditingChanged(_ textField: UITextField) {
        rateLabel.text = textField.text
        fieldEditedClosure?(textField.text)
    }
    
    private func loadImage(for currenct: String) {
        //TODO: Here should be loading image from resources by currency key:
        //      currencyImageView.#imageLiteral(resourceName: "\(flag_\(currency))")
        //  or from particular endpoint (you could you https://github.com/onevcat/Kingfisher for that):
        //      currencyImageView.kf.setImage(URL("somestring"))
        //  or just loading Data(url: url) on separate queue.
    }
}

private extension Int {
    static let maximumFractionDigits = 2
}
