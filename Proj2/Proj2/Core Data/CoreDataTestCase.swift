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
    
    func largestAndSmallest () {
        let smallestRequest = NSFetchRequest<Reading>(entityName: "Reading")
        let sortAscending = NSSortDescriptor(key: #keyPath(Reading.timestamp), ascending: true)
        smallestRequest.sortDescriptors = [sortAscending]
        smallestRequest.fetchLimit = 1
        
        let largerRequest = NSFetchRequest<Reading>(entityName: "Reading")
        let sortDescending = NSSortDescriptor(key: #keyPath(Reading.timestamp), ascending: false)
        largerRequest.sortDescriptors = [sortDescending]
        largerRequest.fetchLimit = 1
        
        let smallest = try! self.context.fetch(smallestRequest) as [Reading]
        let largest = try! self.context.fetch(largerRequest) as [Reading]
        
        print("Smallest: \(String(describing: smallest[0].timestamp!))")
        print("Largest: \(String(describing: largest[0].timestamp!))")
    }
    
    func avgReading () {
        let expression = NSExpressionDescription()
        expression.expression = NSExpression(forFunction: "average:", arguments: [
            NSExpression(forKeyPath: #keyPath(Reading.value))
        ])
        expression.name = "avg"
        expression.expressionResultType = .doubleAttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.propertiesToFetch = [expression]
        request.resultType = .dictionaryResultType
        
        let results = try! self.context.fetch(request)
        let data = results[0] as! [String:Double]
        
        print("Avg reading: \(data["avg"]!)")
    }
    
    func groupedSensors () {
        let avgExpression = NSExpressionDescription()
        avgExpression.expression = NSExpression(forFunction: "average:", arguments: [
            NSExpression(forKeyPath: #keyPath(Reading.value))
        ])
        avgExpression.name = "avg"
        avgExpression.expressionResultType = .doubleAttributeType
        
        let countExpression = NSExpressionDescription()
        countExpression.expression = NSExpression(forFunction: "count:", arguments: [
            NSExpression(forKeyPath: #keyPath(Reading.value))
        ])
        countExpression.name = "count"
        countExpression.expressionResultType = .integer64AttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        request.propertiesToFetch = ["sensor_id", avgExpression, countExpression]
        request.propertiesToGroupBy = ["sensor_id"]
        request.resultType = .dictionaryResultType
        
        let results = try! self.context.fetch(request) as! [[String:Any]]
        
        for result in results {
            print("\(result["sensor_id"]!) - Avg = \(result["avg"]!), Count = \(result["count"]!)")
        }
    }
}
