//
//  MyCurrenciesViewController.swift
//  Test
//
//  Created by Ксения Чепурных on 11.10.2021.
//

import UIKit

final class MyCurrenciesViewController: UIViewController {
    
    var objects: [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(objects)
        view.backgroundColor = .green
    }
}
