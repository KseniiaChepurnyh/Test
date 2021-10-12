//
//  Record.swift
//  Test
//
//  Created by Ксения Чепурных on 31.05.2021.
//

import Foundation

class Record: Codable {
    var value: Float
    var date: String
    var id: String
    var name: String
    
    init(value: Float = 0.0, date: String = "", id: String = "", name: String = "") {
        self.value = value
        self.date = date
        self.id = id
        self.name = name
    }
}
