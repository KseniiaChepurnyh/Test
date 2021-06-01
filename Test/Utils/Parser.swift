//
//  Parser.swift
//  Test
//
//  Created by Ксения Чепурных on 31.05.2021.
//

import Foundation


class Parser: NSObject {
    static let shared = Parser()
    
    var baseURLDinamic = "http://www.cbr.ru/scripts/XML_dynamic.asp?"
    
    var baseURLDaily = "http://www.cbr.ru/scripts/XML_daily.asp?"
    
    var records: [Record] = []
    var currentRecord: Record?
    var record: Record = Record()
    var xmlParser: XMLParser?
    var xmlText = ""
    
    func fetchRecords(startDate: String, endDate: String, completion: @escaping ([Record]) -> Void) {
        guard let url = URL(string: baseURLDinamic +
                                "date_req1=\(startDate)&" +
                                "date_req2=\(endDate)&" +
                                "VAL_NM_RQ=R01235") else { return }
        
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
    
    func fetchRecord(date: String, completion: @escaping (Record) -> Void) {
        let url = URL(string: baseURLDaily + "date_req1=\(date)")!

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, respons, error in
            guard let data = data else { return }

            self.xmlParser = XMLParser(data: data)
            self.xmlParser?.delegate = self
            self.xmlParser?.parse()
            
            for record in self.records {
                if record.id == "R01235" {
                    self.record = record
                }
            }

            DispatchQueue.main.async {
                completion(self.record)
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
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText = xmlText + string
    }
}
