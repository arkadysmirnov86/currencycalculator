//
//  ConvertorViewModelTests.swift
//  currencycalculatorTests
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

import XCTest
@testable import currencycalculator

class ConvertorViewModelTests: XCTestCase {
    
    func testRatesChanged() {
        let successExpectation = expectation(description: "expectation of ratesChanged call")
        let currencyService = FakeCurrencyService()
        let defaultBaseRate = RateModel(currency: "FAKE", value: 100.0)
        
        let viewModel = ConvertorViewModel(currencyService: currencyService, defaultBaseRate: defaultBaseRate)
        viewModel.ratesChanged = {
            successExpectation.fulfill()
        }
        
        currencyService.raiseSuccess()
        
        wait(for: [successExpectation], timeout: 1)
    }
    
    func testisEditingChanged() {
        let successExpectation = expectation(description: "expectation of isEditingChanged call")
        successExpectation.expectedFulfillmentCount = 2
        
        let currencyService = FakeCurrencyService()
        
        let viewModel = ConvertorViewModel(currencyService: currencyService)
        viewModel.isEditingChanged = {
            successExpectation.fulfill()
        }
        
        viewModel.isEditing = true
        viewModel.isEditing = false
        
        wait(for: [successExpectation], timeout: 1)
    }
    
    func testBaseCurrencyChanged() {
        let successExpectation = expectation(description: "expectation of baseCurrency update and ratesChanged call")
        
        let expectedCurrency = "currency5"
        
        let currencyService = FakeCurrencyService()
        let defaultBaseRate = RateModel(currency: "FAKE", value: 100.0)
        
        let viewModel = ConvertorViewModel(currencyService: currencyService, defaultBaseRate: defaultBaseRate)
        viewModel.ratesChanged = {
            if viewModel.baseCurrency == expectedCurrency {
                successExpectation.fulfill()
            }
        }
        currencyService.raiseSuccess()
        viewModel.baseCurrency = expectedCurrency
        currencyService.raiseSuccess()
        wait(for: [successExpectation], timeout: 1)
    }
    
    func testRatesOrderingAfterBaseCarrencyChanged() {
        let successExpectation = expectation(description: "expectation of baseCurrency update and ratesChanged call")
        
        let expectedCurrency = "currency5"
        
        let currencyService = FakeCurrencyService()
        let defaultBaseRate = RateModel(currency: "FAKE", value: 100.0)
        
        let viewModel = ConvertorViewModel(currencyService: currencyService, defaultBaseRate: defaultBaseRate)
        viewModel.ratesChanged = {
            if viewModel.baseCurrency == expectedCurrency, viewModel.rates[1].currency == defaultBaseRate.currency
                && viewModel.rates[1].value == defaultBaseRate.value {
                
                successExpectation.fulfill()
            }
        }
        currencyService.raiseSuccess()
        viewModel.baseCurrency = expectedCurrency
        currencyService.raiseSuccess()
        wait(for: [successExpectation], timeout: 1)
    }

}
