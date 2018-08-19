//
//  CurrencyServiceTests.swift
//  currencycalculatorTests
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import XCTest
@testable import currencycalculator

class CurrencyServiceTests: XCTestCase {
    
    func testCurrencyServiceSuccessResult() {
        let successExpectation = expectation(description: "expectation of successClosure call")
        successExpectation.assertForOverFulfill = false
        let errorExpectation = expectation(description: "expectation of errorClosure call")
        errorExpectation.isInverted = true
        let dataProvider = FakeDataProvider(isSuccess: true)
        
        let currencyService = CurrencyService(dataProvider: dataProvider)
        currencyService.subscribeToRatesUpdate(
            baseCurrency: "EUR",
            successClosure: {
                ratesEntity in
            
                successExpectation.fulfill()
            },
            errorClosure: {
                error in
                
                errorExpectation.fulfill()
            })
        
        wait(for: [errorExpectation, successExpectation], timeout: 3)
    }
    
    func testCurrencyServiceSuccessError() {
        let successExpectation = expectation(description: "expectation of successClosure call")
        successExpectation.isInverted = true
        let errorExpectation = expectation(description: "expectation of errorClosure call")
        errorExpectation.assertForOverFulfill = false
        
        let dataProvider = FakeDataProvider(isSuccess: false)
        
        let currencyService = CurrencyService(dataProvider: dataProvider)
        currencyService.subscribeToRatesUpdate(
            baseCurrency: "EUR",
            successClosure: {
                ratesEntity in
                
                successExpectation.fulfill()
            },
            errorClosure: {
                error in
                switch error {
                case Errors.fakeError:
                    errorExpectation.fulfill()
                default:
                    XCTFail("unexpectable error: \(error.localizedDescription)")
                }
            }
        )
        
        wait(for: [errorExpectation, successExpectation], timeout: 3)
    }
    
    func testCurrencyServiceSuccessResultAsync() {
        let successExpectation = expectation(description: "expectation of successClosure call")
        successExpectation.assertForOverFulfill = false
        successExpectation.isInverted = true
        successExpectation.expectedFulfillmentCount = 2
        let errorExpectation = expectation(description: "expectation of errorClosure call")
        errorExpectation.isInverted = true
        let dataProvider = FakeDataProviderWithTimeout(isSuccess: true)
        
        let currencyService = CurrencyService(dataProvider: dataProvider)
        currencyService.subscribeToRatesUpdate(
            baseCurrency: "EUR",
            successClosure: {
                ratesEntity in
                successExpectation.fulfill()
            },
            errorClosure: {
                error in
                errorExpectation.fulfill()
            })
        
        wait(for: [errorExpectation, successExpectation], timeout: 7)
    }
    
    func testCurrencyServiceSuccessErrorAsync() {
        let errorExpectation = expectation(description: "expectation of errorClosure call")
        errorExpectation.assertForOverFulfill = false
        errorExpectation.isInverted = true
        errorExpectation.expectedFulfillmentCount = 2
        let successExpectation = expectation(description: "expectation of succesClosure call")
        successExpectation.isInverted = true
        let dataProvider = FakeDataProviderWithTimeout(isSuccess: false)
        
        let currencyService = CurrencyService(dataProvider: dataProvider)
        currencyService.subscribeToRatesUpdate(
            baseCurrency: "EUR",
            successClosure: {
                ratesEntity in
                successExpectation.fulfill()
        },
            errorClosure: {
                error in
                errorExpectation.fulfill()
        })
        
        wait(for: [errorExpectation, successExpectation], timeout: 7)
    }
    
}
