//
//  Parser.swift
//  Test
//
//  Created by Ксения Чепурных on 31.05.2021.
//

import Foundation


class Parser: NSObject {
    static let shared = Parser()
    
    private var baseURLDynamic = "http://www.cbr.ru/scripts/XML_dynamic.asp?"
    
    private var baseURLDaily = "http://www.cbr.ru/scripts/XML_daily.asp?"
    
    private var records: [Record] = []
    private var currentRecord: Record?
    private var record: Record = .init()
    private var xmlParser: XMLParser?
    private var xmlText = ""
    private var date: String = ""
    
    func fetchRecords(
        startDate: String,
        endDate: String,
        code: String,
        completion: @escaping ([Record]) -> Void
    ) {
        records = []
        guard let url = URL(string: baseURLDynamic +
                                "date_req1=\(startDate)&" +
                                "date_req2=\(endDate)&" +
                                "VAL_NM_RQ=\(code)") else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            
            self.xmlParser = XMLParser(data: data)
            self.xmlParser?.delegate = self
            self.xmlParser?.parse()
            
            DispatchQueue.main.async {
                completion(self.records.reversed())
            }
        }
        task.resume()
        
    }
    
    func fetchRecord(currencies: [Currency], completion: @escaping ([Record]) -> Void) {
        records = []
        guard let url = URL(string: baseURLDaily) else { return }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, respons, error in
            guard let data = data else { return }

            self.xmlParser = XMLParser(data: data)
            self.xmlParser?.delegate = self
            self.xmlParser?.parse()
            
            
            var myRecords: [Record] = []
            self.records.forEach { record in
                currencies.forEach { currensy in
                    if record.id == currensy.code {
                        record.date = self.date
                        myRecords.append(record)
                    }
                }
            }

            DispatchQueue.main.async {
                completion(myRecords)
            }
        }
        task.resume()
    }
}

extension Parser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        xmlText = ""
        if elementName == "Record" {
            currentRecord = Record()
        }
        
        if let date = attributeDict["Date"] {
            currentRecord?.date = date
        }
        
        if elementName == "Valute" {
            currentRecord = Record()
            if let id = attributeDict["ID"] {
                currentRecord?.id = id
            }
        }
        
        if elementName == "ValCurs" {
            if let date = attributeDict["Date"] {
                self.date = date
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Value" {
            if let value = Float(xmlText.replacingOccurrences(of: ",", with: ".")) {
                currentRecord?.value = value
            }
        }
        
        if elementName == "Record" {
            if let record = currentRecord {
                self.records.append(record)
            }
        }
        
        if elementName == "Valute" {
            if let record = currentRecord {
                self.records.append(record)
            }
        }
        
        if elementName == "Name" {
            currentRecord?.name = xmlText
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText = xmlText + string
    }
}
