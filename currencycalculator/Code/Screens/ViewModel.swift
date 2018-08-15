//
//  ViewModel.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

struct RateModel {
    var currency: String
    var value: Decimal
}

class ViewModel {
    
    var ratesChanged: VoidClosure?
    
    private (set) var rates: [RateModel] = [RateModel(currency: "EUR", value: 100)]
    
    var base: String = "EUR" {
        didSet {
            if let index = rates.index(where: { $0.currency == base }) {
                let baseRate = rates.remove(at: index)
                rates.insert(baseRate, at: 0)
                self.fireTimer(base: base)
            }
        }
    }
    
    private let dataProvider: DataProvider
    private var timer: Timer?
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        fireTimer(base: self.base)
    }
    
    private func fireTimer(base: String) {
        
        if self.timer != nil {
            timer?.invalidate()
        }
        
        self.timer = Timer(timeInterval: 1, repeats: true) {
            [weak self] _ in
            
            self?.dataProvider.getRates(
                base: base,
                successHandler: {
                    (ratesList) in
                    
                    self?.process(ratesList: ratesList)
                    
                }, errorHandler: {
                    (error) in
                    //TODO: add error handling
                }
            )
        }
    }
    
    private func process(ratesList: RatesList) {
        guard base == ratesList.base else {
            return
        }
        
        let baseValue = rates[0].value
        
        ratesList.rates.forEach { (key, value) in
            let newRate = RateModel(currency: key, value: value * baseValue)
            
            if let existingIndex = rates.index(where: { $0.currency == key } ) {
                rates[existingIndex] = newRate
            } else {
                rates.append(newRate)
            }
        }
        
        ratesChanged?()
    }
}

