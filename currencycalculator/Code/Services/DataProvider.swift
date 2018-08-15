//
//  DataProvider.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

class DataProvider {
    
    enum Errors: Error {
        case invalidURL
        case dataIsEmpty
    }
    
    func getRates(base: String, successHandler: @escaping (RatesList) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let url = URL(string: .baseURL + base) {
            let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
                if let error = error {
                    errorHandler(error)
                } else {
                    guard let data = data else {
                        errorHandler(Errors.dataIsEmpty)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(RatesList.self, from: data)
                        successHandler(result)
                    } catch {
                        errorHandler(error)
                    }
                }
            }
            task.resume()
        } else {
            errorHandler(Errors.invalidURL)
        }
        
    }
}

private extension String {
    static let baseURL = "https://revolut.duckdns.org/latest?base="
}
