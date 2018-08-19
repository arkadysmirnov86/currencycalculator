//
//  Coordinator.swift
//  currencycalculator
//
//  Created by Arkady Smirnov on 8/19/18.
//  Copyright © 2018 Arkady Smirnov. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

extension Coordinator {
    func instantiate<T: UIViewController>(_ type: T.Type, from storyboardName: String = "Main") -> T {
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        let className = String(describing: type)
        
        //remark: it isn't right to force unwrap, but we have to fail in that case
        return storyBoard.instantiateViewController(withIdentifier: className) as! T
    }
}
