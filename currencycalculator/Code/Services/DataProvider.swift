//
//  DataProvider.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

class DataProvider: DataProviderType {
    
    func getRates(base: String, successHandler: @escaping (RatesList) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let url = URL(string: .baseURL + base) {
            let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
                if let error = error {
                    DispatchQueue.main.async(errorHandler, with: error)
                } else {
                    guard let data = data else {
                        DispatchQueue.main.async(errorHandler, with: DataProviderError.dataIsEmpty)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(RatesList.self, from: data)
                        DispatchQueue.main.async(successHandler, with: result)
                    } catch {
                        DispatchQueue.main.async(errorHandler, with: error)
                    }
                }
            }
            task.resume()
        } else {
            errorHandler(DataProviderError.invalidURL)
        }
        
    }
}

//TODO: move it to configuration (or config layer)
private extension String {
    static let baseURL = "https://revolut.duckdns.org/latest?base="
}
