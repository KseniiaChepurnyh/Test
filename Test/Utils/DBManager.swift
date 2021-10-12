//
//  DBManager.swift
//  Test
//
//  Created by Ксения Чепурных on 12.10.2021.
//

import Foundation

final class DBManager {
    
    static let shared = DBManager()
    
    func getCurrencies(completion: @escaping ([Currency]) -> Void) {
        var savedCurrencies: [Currency] = []
        if let data = UserDefaults.standard.data(forKey: "selectedCurrencies") {
            do {
                let decoder = JSONDecoder()
                savedCurrencies = try decoder.decode([Currency].self, from: data)
            } catch {
                print("Unable to decode currencies (\(error))")
            }
        }
        completion(savedCurrencies)
    }
    
    func saveCurrencies(for currencies: [Currency]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currencies)
            UserDefaults.standard.set(data, forKey: "selectedCurrencies")
        } catch {
            print("Unable to encode currencies (\(error))")
        }
    }
    
    func saveMyRecords(for records: [Record]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(records)
            UserDefaults.standard.set(data, forKey: "MyRecords")
        } catch {
            print("Unable to encode records (\(error))")
        }
    }
    
    func getMyRecords(completion: @escaping ([Record]) -> Void) {
        var records: [Record] = []
        if let data = UserDefaults.standard.data(forKey: "selectedCurrencies") {
            do {
                let decoder = JSONDecoder()
                records = try decoder.decode([Record].self, from: data)
            } catch {
                print("Unable to decode records (\(error))")
            }
        }
        completion(records)
    }
}
