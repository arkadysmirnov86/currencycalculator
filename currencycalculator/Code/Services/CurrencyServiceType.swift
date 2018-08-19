//
//  CurrencyServiceType.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

protocol CurrencyServiceType: class {
    var baseCurrency: String? { get set }
    func subscribeToRatesUpdate(baseCurrency: String, successClosure: @escaping (RatesEntity) -> Void, errorClosure: ((Error) -> Void)?) 
}
