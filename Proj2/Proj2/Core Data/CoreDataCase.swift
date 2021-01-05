//
//  CoreDataCase.swift
//  Proj2
//
//  Created by Magiczne on 05/01/2021.
//

import CoreData
import UIKit
import Foundation

class CoreDataTestCase {
    static func run (_ readings: String) {
        guard let ad = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let moc = ad.persistentContainer.viewContext
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Reading")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! moc.execute(deleteRequest)
        
        fetchRequest = NSFetchRequest(entityName: "Sensor")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! moc.execute(deleteRequest)
        
        let decoder = JSONDecoder()
    
        if let sensorsUrl = Bundle.main.url(forResource: "sensors", withExtension: "json") {
            do {
                let data = try Data(contentsOf: sensorsUrl)
                let jsonData = try decoder.decode([FSensor].self, from: data)
                
                for entry in jsonData {
                    let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: moc)
                    let sensor = NSManagedObject(entity: entity!, insertInto: moc)
                    sensor.setValue(entry.id, forKey: "id")
                    sensor.setValue(entry.description, forKey: "desc")
                    
                    try? moc.save()
                }
            } catch {
                print("Sensors error: \(error)")
            }
        }
        
        if let readingsUrl = Bundle.main.url(forResource: readings, withExtension: "json") {
            do {
                let data = try Data(contentsOf: readingsUrl)
                let jsonData = try decoder.decode([FReading].self, from: data)
                
                for entry in jsonData {
                    let entity = NSEntityDescription.entity(forEntityName: "Reading", in: moc)
                    let reading = NSManagedObject(entity: entity!, insertInto: moc)
                    reading.setValue(entry.timestamp, forKey: "timestamp")
                    reading.setValue(entry.sensor_id, forKey: "sensor_id")
                    reading.setValue(entry.value, forKey: "value")
                    
                    try? moc.save()
                }
            } catch {
                print("Readings error: \(error)")
            }
        }
        
        
        
    }
}
