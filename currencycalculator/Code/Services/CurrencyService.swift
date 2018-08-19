//
//  CurrencyService.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

class CurrencyService {
    
    static let timeInterval: TimeInterval = 1
    
    private var dataProvider: DataProviderType
    private weak var timer: Timer?
    private var subscriptionClosure: ((RatesEntity) -> Void)?
    
    var baseCurrency: String?
    
    init(dataProvider: DataProviderType) {
        self.dataProvider = dataProvider
        self.timer = Timer.scheduledTimer(timeInterval: CurrencyService.timeInterval, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    func subscribeToRatesUpdate(baseCurrency: String, successClosure: @escaping (RatesEntity) -> Void) {
        self.baseCurrency = baseCurrency
        self.subscriptionClosure = successClosure
    }
    
    @objc private func timerTick() {
        guard let baseCurrency = baseCurrency else {
            return
        }
        
        self.dataProvider.getRates(
            base: baseCurrency,
            successHandler: { ratesEntity in
                self.subscriptionClosure?(ratesEntity)
            },
            errorHandler: { error in
                //TODO: add error handling
            }
        )
    }
    
    deinit {
        self.timer?.invalidate()
    }
}
