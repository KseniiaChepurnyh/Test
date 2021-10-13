//
//  Extension Date.swift
//  Test
//
//  Created by Ксения Чепурных on 01.06.2021.
//

import Foundation


extension Date {
    
    func string() -> String {
        return DateFormatter.withFormat("dd/MM/YYYY").string(from: self)
    }
    
    func monthFromNowDate() -> Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: self) ?? Date()
    }
    
}

extension DateFormatter {
    
    static func withFormat(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }
    
}
