//
//  Currency.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import Foundation

class Currency: Equatable {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return
        lhs.code == rhs.code &&
        lhs.name == rhs.name
    }
    
    var name: String
    var code: String
    
    init(name: String = "", code: String = "") {
        self.name = name
        self.code = code
    }
}
