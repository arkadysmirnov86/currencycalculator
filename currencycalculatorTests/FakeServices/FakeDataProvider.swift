//
//  FakeDataProvider.swift
//  currencycalculatorTests
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation
@testable import currencycalculator

class FakeDataProvider: DataProviderType {
    
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func getRates(base: String, successHandler: @escaping (RatesEntity) -> Void, errorHandler: @escaping (Error) -> Void) {
        if isSuccess {
            let ratesEntity = RatesEntity.fakeFactoryMethod(base: base)
            DispatchQueue.main.async(successHandler, with: ratesEntity )
        } else {
            DispatchQueue.main.async(errorHandler, with: Errors.fakeError)
        }
    }
    
}
