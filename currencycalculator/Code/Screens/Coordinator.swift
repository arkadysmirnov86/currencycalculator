//
//  Coordinator.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class CalculatorCoordinator: Coordinator {
    
    let dataProvider: DataProviderType
    let window: UIWindow
    
    init(dataProvider: DataProviderType, window: UIWindow) {
        self.dataProvider = dataProvider
        self.window = window
    }
    
    func start() {
        let viewController = self.instantiate(ViewController.self)
        let viewModel = ViewModel(dataProvider: dataProvider)
        viewController.viewModel = viewModel
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

extension Coordinator {
    func instantiate<T: UIViewController>(_ type: T.Type, from storyboardName: String = "Main") -> T {
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        let className = String(describing: type)
        
        //remark: it isn't right to force unwrap, but we have to fail in that case
        return storyBoard.instantiateViewController(withIdentifier: className) as! T
    }
}
