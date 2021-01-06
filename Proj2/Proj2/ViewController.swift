//
//  ViewController.swift
//  Proj2
//
//  Created by Magiczne on 18/12/2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var start: DispatchTime = DispatchTime.now()
    var end: DispatchTime = DispatchTime.now()
    let file = "readings-1000"
    
    let fileTestCase = FileTestCase()
    let sqliteTestCase = SQLiteTestCase()
    let coreDataTestCase = CoreDataTestCase()
    
    func startMeasure() {
        self.start = DispatchTime.now()
    }
    
    func stopMeasure(_ tag: String) {
        self.end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("\(tag) finished in \(timeInterval) seconds\n")
    }
    
    @IBAction func onFileTest() {
        self.startMeasure()
        self.fileTestCase.loadData(self.file)
        self.stopMeasure("File loading test")
    }
    
    @IBAction func onSQLiteTest() {
        self.startMeasure()
        self.sqliteTestCase.loadData(sensors: self.fileTestCase.sensorsData, readings: self.fileTestCase.readingsData)
        self.stopMeasure("SQLite loading test")
    }
    
    
    @IBAction func onCoreDataTest() {
        self.startMeasure()
        self.coreDataTestCase.loadData(sensors: self.fileTestCase.sensorsData, readings: self.fileTestCase.readingsData)
        self.stopMeasure("Core Data loading test")
        
        self.startMeasure()
        self.coreDataTestCase.readData()
        self.stopMeasure("Core Data read")
    }
}

