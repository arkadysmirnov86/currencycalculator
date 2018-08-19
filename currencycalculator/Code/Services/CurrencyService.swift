//
//  CurrencyService.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

class CurrencyService: CurrencyServiceType {
    
    static let timeInterval: TimeInterval = 1
    
    private var dataProvider: DataProviderType
    private weak var timer: Timer?
    private var succesClosure: ((RatesEntity) -> Void)?
    private var errorClosure: ((Error) -> Void)?
    
    var baseCurrency: String?
    
    init(dataProvider: DataProviderType) {
        self.dataProvider = dataProvider
        self.timer = Timer.scheduledTimer(timeInterval: CurrencyService.timeInterval, target: self, selector: #selector(fetchRates), userInfo: nil, repeats: true)
    }
    
    func subscribeToRatesUpdate(baseCurrency: String, successClosure: @escaping (RatesEntity) -> Void, errorClosure: ((Error) -> Void)?) {
        self.baseCurrency = baseCurrency
        self.succesClosure = successClosure
        self.errorClosure = errorClosure
    }
    
    @objc private func fetchRates() {
        guard let baseCurrency = baseCurrency else {
            return
        }
        
        self.dataProvider.getRates(
            base: baseCurrency,
            successHandler: { ratesEntity in
                self.succesClosure?(ratesEntity)
            },
            errorHandler: { error in
                self.errorClosure?(error)
            }
        )
    }
    
    deinit {
        self.timer?.invalidate()
    }
}
