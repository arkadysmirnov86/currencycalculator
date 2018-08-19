//
//  DataProviderError.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

enum DataProviderError: Error {
    case dataIsEmpty
    case invalidRequestURL
}

