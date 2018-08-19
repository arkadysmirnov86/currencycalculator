//
//  ConvertorCoordinator.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

class ConvertorCoordinator: Coordinator {
    
    let dataProvider: DataProviderType
    let window: UIWindow
    
    init(dataProvider: DataProviderType, window: UIWindow) {
        self.dataProvider = dataProvider
        self.window = window
    }
    
    func start() {
        let viewController = self.instantiate(ConvertorViewController.self)
        let currencyService = CurrencyService(dataProvider: dataProvider)
        let viewModel = ConvertorViewModel(currencyService: currencyService)
        viewController.viewModel = viewModel
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
