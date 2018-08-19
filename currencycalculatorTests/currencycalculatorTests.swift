//
//  currencycalculatorTests.swift
//  currencycalculatorTests
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import XCTest
@testable import currencycalculator

class currencycalculatorTests: XCTestCase {

    // it's not requared to test API methods.
    // TODO: remove or comment it
    func testGetRates() {
        let exp = expectation(description: "getRates")
        let dataProvider = DataProvider()
        dataProvider.getRates(
            base: "EUR",
            successHandler: {
                rates in
                exp.fulfill()
            },
            errorHandler: {
                error in
                XCTFail(error.localizedDescription)
            }
        )
        wait(for: [exp], timeout: 2)
    }
    
}
