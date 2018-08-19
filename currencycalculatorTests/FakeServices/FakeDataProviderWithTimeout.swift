//
//  FakeDataProviderWithTimeout.swift
//  currencycalculatorTests
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation
@testable import currencycalculator

class FakeDataProviderWithTimeout: DataProviderType {
    
    var isSuccess: Bool
    
    var counter = 0
    var invalidateAfter: Int
    
    init(isSuccess: Bool, invalidateAfter: Int = 2) {
        self.isSuccess = isSuccess
        self.invalidateAfter = invalidateAfter
    }
    
    func getRates(base: String, successHandler: @escaping (RatesEntity) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard counter < invalidateAfter else {
            return
        }
        
        let time = counter == 1 ? DispatchTime.now() : DispatchTime(uptimeNanoseconds:  DispatchTime.now().uptimeNanoseconds +  2 * 1000000000)
        counter += 1
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: time) {
            if self.isSuccess {
                let ratesEntity = RatesEntity.fakeFactoryMethod(base: base)
                DispatchQueue.main.async(successHandler, with: ratesEntity )
            } else {
                DispatchQueue.main.async(errorHandler, with: Errors.fakeError)
            }
        }
    }

}

