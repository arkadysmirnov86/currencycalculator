//
//  DispatchQueue.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func async<T>(_ closure: @escaping (T) -> Void, with value: T) {
        self.async {
            closure(value)
        }
    }
    
}
