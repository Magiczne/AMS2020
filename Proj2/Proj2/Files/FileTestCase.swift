//
//  FileTestCase.swift
//  Proj2
//
//  Created by Magiczne on 18/12/2020.
//

import Foundation

class FileTestCase {
    static func run(_ readings: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.readingFormat)
        
        if let sensorsUrl = Bundle.main.url(forResource: "sensors", withExtension: "json") {
            do {
                let data = try Data(contentsOf: sensorsUrl)
                let jsonData = try decoder.decode([FSensor].self, from: data)
                
                print("Sensors count: \(jsonData.count)")
            } catch {
                print("Sensors error: \(error)")
            }
        }
        
        if let readingsUrl = Bundle.main.url(forResource: readings, withExtension: "json") {
            do {
                let data = try Data(contentsOf: readingsUrl)
                let jsonData = try decoder.decode([FReading].self, from: data)
                
                print("Data count: \(jsonData.count)")
            } catch {
                print("Readings error: \(error)")
            }
        }
    }
}
