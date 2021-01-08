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
        let min = self.readingsData.min()
        let max = self.readingsData.max()
        
        return """
        Smallest: \(min!.timestamp)
        Largest: \(max!.timestamp)
        """
    }
    
    func avgReading () -> String {
        let sum = self.readingsData.reduce(Float.zero, { sum, newVal in
            return sum + newVal.value
        })
        let avg = sum / Float.init(self.readingsData.count)
        
        return "Average: \(avg)"
    }
    
    func groupedSensors () -> String {
        let dict = Dictionary(grouping: self.readingsData, by: { $0.sensor_id })
            .sorted(by: { $0.0 < $1.0 })
        
        var msg = ""
        for group in dict {
            let sum = group.value.reduce(Float.zero, { sum, newVal in
                return sum + newVal.value
            })
            let avg = sum / Float.init(group.value.count)
            
            msg += "\(group.key) - Avg = \(avg), Count = \(group.value.count)\n"
        }
        
        return msg
    }
}
