//
//  ConvertorViewModel.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

class ConvertorViewModel {
    
    private var ratesEntity: RatesEntity?
    
    var ratesChanged: VoidClosure?
    private (set) var rates: [RateModel] = [RateModel(currency: "EUR", value: 100)]
    
    var baseValue: Decimal = 100.0 {
        didSet {
            rates[0].value = baseValue
            if let ratesList = ratesEntity {
                process(ratesEntity: ratesList)
            }
        }
    }
    var baseCurrency: String = "EUR" {
        didSet {
            if let index = rates.index(where: { $0.currency == baseCurrency }) {
                let baseRate = rates.remove(at: index)
                rates.insert(baseRate, at: 0)
                self.currencyService.baseCurrency = baseCurrency
            }
        }
    }
    
    var isEditingChanged: VoidClosure?
    var isEditing: Bool = false {
        didSet {
            isEditingChanged?()
        }
    }
    
    private let currencyService: CurrencyService
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
        self.currencyService.subscribeToRatesUpdate(baseCurrency: self.baseCurrency) {
            ratesEntity in
            
            self.ratesEntity = ratesEntity
            self.process(ratesEntity: ratesEntity)
        }
    }
    
    private func process(ratesEntity: RatesEntity) {
        guard baseCurrency == ratesEntity.base else {
            return
        }
        
        let baseValue = rates[0].value
        
        ratesEntity.rates.forEach { (key, value) in
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
