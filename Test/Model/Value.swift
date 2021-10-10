//
//  Value.swift
//  Test
//
//  Created by Ксения Чепурных on 01.06.2021.
//

import Foundation


final class Value {
    
    static var savedValue: Float! {
        get {
            return UserDefaults.standard.float(forKey: "value")
        }
        set {
            let defaults = UserDefaults.standard
            if let value = newValue {
                defaults.set(value, forKey: "value")
            }
        }
    }
}
