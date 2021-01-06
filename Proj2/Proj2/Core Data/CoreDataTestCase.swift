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
    let context: NSManagedObjectContext
    
    init () {
        let ad = UIApplication.shared.delegate as! AppDelegate
        self.context = ad.persistentContainer.viewContext
    }
    
    func loadData (sensors: [FSensor], readings: [FReading]) {
        // Truncate data
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Reading")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! self.context.execute(deleteRequest)
        
        fetchRequest = NSFetchRequest(entityName: "Sensor")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! self.context.execute(deleteRequest)
    
        // Insert sensors data
        for entry in sensors {
            let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: self.context)
            let sensor = NSManagedObject(entity: entity!, insertInto: self.context)
            sensor.setValue(entry.id, forKey: "id")
            sensor.setValue(entry.description, forKey: "desc")
        }
        try? self.context.save()
        
        // Insert readings data
        for entry in readings {
            let entity = NSEntityDescription.entity(forEntityName: "Reading", in: self.context)
            let reading = NSManagedObject(entity: entity!, insertInto: self.context)
            reading.setValue(entry.timestamp, forKey: "timestamp")
            reading.setValue(entry.sensor_id, forKey: "sensor_id")
            reading.setValue(entry.value, forKey: "value")
        }
        try? self.context.save()
    }
    
    func readData () {
        let sensors = try? self.context.fetch(Sensor.fetchRequest() as NSFetchRequest<Sensor>)
        
        print(sensors!)
    }
}
