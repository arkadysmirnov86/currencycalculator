//
//  RatesEntity+Tests.swift
//  currencycalculatorTests
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation
@testable import currencycalculator

extension RatesEntity {
    
    static func fakeFactoryMethod(base: String) -> RatesEntity {
        var rates = [String: Decimal]()
        for i in 1...100 {
            rates["currency\(i)"] = Decimal(integerLiteral: i)
        }
        let ratesEntity = RatesEntity(base: base, date: Date(), rates: rates)
        return ratesEntity
    }
}

