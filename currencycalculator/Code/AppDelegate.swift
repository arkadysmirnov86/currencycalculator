//
//  AppDelegate.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/15/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        self.window = window
        
        //TODO: you could store it in .plist or .xcconfig
        let apiBaseUrlString = "https://revolut.duckdns.org/"
        
        let dataProvider = DataProvider(baseURL: apiBaseUrlString)
        let rootCoordinator = ConvertorCoordinator(dataProvider: dataProvider, window: window)
        rootCoordinator.start()
        
        return true
    }

}

