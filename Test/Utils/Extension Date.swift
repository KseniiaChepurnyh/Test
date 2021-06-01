//
//  Extension Date.swift
//  Test
//
//  Created by Ксения Чепурных on 01.06.2021.
//

import Foundation


extension Date {
    func fogmatedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let result = dateFormatter.string(from: date)
        
        return result
    }
}
