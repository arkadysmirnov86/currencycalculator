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
    
    var baseCurrency: String = "EUR" {
        didSet {
            if let index = rates.index(where: { $0.currency == baseCurrency }) {
                let baseRate = rates.remove(at: index)
                rates.insert(baseRate, at: 0)
                self.fireTimer(base: baseCurrency)
            }
        }
    }
    
    var isEditing: Bool = false
    
    var baseValue: Decimal = 100.0
    
    private let dataProvider: DataProviderType
    private weak var timer: Timer?
    
    init(dataProvider: DataProviderType) {
        self.dataProvider = dataProvider
        fireTimer(base: self.baseCurrency)
    }
    
    private func fireTimer(base: String) {
        
        if self.timer != nil {
            timer?.invalidate()
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc private func timerTick() {
        self.dataProvider.getRates(
            base: baseCurrency,
            successHandler: {
                (ratesList) in
                
                self.process(ratesList: ratesList)
                
            }, errorHandler: {
                (error) in
                //TODO: add error handling
            }
        )
    }
    
    private func process(ratesList: RatesList) {
        guard baseCurrency == ratesList.base else {
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
    
    deinit {
        timer?.invalidate()
    }
}

