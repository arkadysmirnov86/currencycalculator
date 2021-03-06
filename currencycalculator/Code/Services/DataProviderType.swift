//
//  DataProviderType.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

protocol DataProviderType: class {
    func getRates(base: String, successHandler: @escaping (RatesEntity) -> Void, errorHandler: @escaping (Error) -> Void)
}
