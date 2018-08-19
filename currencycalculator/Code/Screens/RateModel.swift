//
//  RateModel.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

struct RateModel {
    var currency: String
    var value: Decimal
    
    var description: String {
        return NSLocalizedString(currency, comment: "")
    }
}
