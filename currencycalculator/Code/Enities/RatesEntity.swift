//
//  RatesList.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import Foundation

struct RatesEntity: Decodable {
    var base: String
    var date: Date
    var rates: [String: Decimal]
    
    enum CodingKeys: CodingKey {
        case base, date, rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RatesEntity.CodingKeys.self)
        
        self.base = try container.decode(String.self, forKey: .base)
        
        let dateString = try container.decode(String.self, forKey: .base)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date = formatter.date(from: dateString) ?? Date()
        
        self.rates = try container.decode([String: Decimal].self, forKey: .rates)
    }
}
