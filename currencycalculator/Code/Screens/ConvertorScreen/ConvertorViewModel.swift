//
//  ConvertorViewModel.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

class ConvertorViewModel {
    private let currencyService: CurrencyServiceType
    private var ratesEntity: RatesEntity?
    
    var ratesChanged: VoidClosure? 
    private (set) var rates: [RateModel]
    
    var baseValue: Decimal {
        didSet {
            rates[0].value = baseValue
            if let ratesList = ratesEntity {
                process(ratesEntity: ratesList)
            }
        }
    }
    var baseCurrency: String {
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
    
    init(currencyService: CurrencyServiceType, baseRate: RateModel = .default) {
        self.baseCurrency = baseRate.currency
        self.baseValue = baseRate.value
        self.currencyService = currencyService
        self.rates = [baseRate]
        self.currencyService.subscribeToRatesUpdate(baseCurrency: self.baseCurrency, successClosure: {
            ratesEntity in
            
            self.ratesEntity = ratesEntity
            self.process(ratesEntity: ratesEntity)
        }, errorClosure: {
            error in
            //TODO: handle error if needed
            
            print("error: \(error)")
        })
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

private extension RateModel {
    static let `default` = RateModel(currency: "EUR", value: 100)
}
