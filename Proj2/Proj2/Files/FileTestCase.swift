//
//  FileTestCase.swift
//  Proj2
//
//  Created by Magiczne on 18/12/2020.
//

import Foundation

class FileTestCase {
    var sensorsData: [FSensor]
    var readingsData: [FReading]
    
    init () {
        self.sensorsData = []
        self.readingsData = []
    }
    
    func loadData (_ file: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.readingFormat)
        
        if let sensorsUrl = Bundle.main.url(forResource: "sensors", withExtension: "json") {
            do {
                let data = try Data(contentsOf: sensorsUrl)
                let jsonData = try decoder.decode([FSensor].self, from: data)
                
                self.sensorsData = jsonData
            } catch {
                print("Sensors error: \(error)")
            }
        }
        
        if let readingsUrl = Bundle.main.url(forResource: file, withExtension: "json") {
            do {
                let data = try Data(contentsOf: readingsUrl)
                let jsonData = try decoder.decode([FReading].self, from: data)
                
                self.readingsData = jsonData
            } catch {
                print("Readings error: \(error)")
            }
        }
    }
    
    func largestAndSmallest () -> String {
        return ""
    }
    
    func avgReading () -> String {
        return ""
    }
    
    func groupedSensors () -> String {
        return ""
    }
}
