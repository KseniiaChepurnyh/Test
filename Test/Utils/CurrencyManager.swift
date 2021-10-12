//
//  CurrencyManager.swift
//  Test
//
//  Created by Ксения Чепурных on 10.10.2021.
//

import Foundation

class CurrencyManager: NSObject {
    
    static let shared = CurrencyManager()
    
    private let baseURL = "http://www.cbr.ru/scripts/XML_val.asp?d=0"
    
    private var currencyArray: [Currency] = []
    private var currentCurrency: Currency?
    private var xmlParser: XMLParser?
    private var xmlText = ""
    
    func fetchCurrencyList(completion: @escaping ([Currency]) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            
            self.xmlParser = XMLParser(data: data)
            self.xmlParser?.delegate = self
            self.xmlParser?.parse()
            
            DispatchQueue.main.async {
                completion(self.currencyArray)
            }
        }
        task.resume()
    }
    
}

extension CurrencyManager: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        xmlText = ""
        if elementName == "Item" {
            currentCurrency = .init()
        }
        
        if let code = attributeDict["ID"] {
            currentCurrency?.code = code
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Item" {
            if let currentCurrency = currentCurrency {
                self.currencyArray.append(currentCurrency)
            }
        }
        
        if elementName == "Name" {
            currentCurrency?.name = xmlText
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText = xmlText + string
    }
    
}
