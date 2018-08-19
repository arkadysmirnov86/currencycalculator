//
//  FakeCurrencyService.swift
//  currencycalculatorTests
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation
@testable import currencycalculator

class FakeCurrencyService: CurrencyServiceType  {
    
    var baseCurrency: String?
    var successClosure: ((RatesEntity) -> Void)?
    var errorClosure: ((Error) -> Void)?
    
    func subscribeToRatesUpdate(baseCurrency: String, successClosure: @escaping (RatesEntity) -> Void, errorClosure: ((Error) -> Void)?) {
        self.successClosure = successClosure
        self.errorClosure = errorClosure
        self.baseCurrency = baseCurrency
    }
    
    func raiseSuccess() {
        self.successClosure?(RatesEntity.fakeFactoryMethod(base: self.baseCurrency ?? ""))
    }
    
    func raiseError() {
        self.errorClosure?(Errors.fakeError)
    }
    
}
