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
    var fileTestRan: Bool = false
    let file = "readings-100000"
    
    let fileTestCase = FileTestCase()
    let sqliteTestCase = SQLiteTestCase()
    let coreDataTestCase = CoreDataTestCase()
    
    func updateTextViewText(_ msg: String, clear: Bool = false) {
        if (clear) {
            self.textView.text = ""
        }
        
        self.textView.text = "\(self.textView.text!)\n\(msg)"
    }
    
    func startMeasure() {
        self.start = DispatchTime.now()
    }
    
    func stopMeasure(_ tag: String) {
        self.end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        let message = "\(tag) finished in \(timeInterval) seconds\n"
        
        self.updateTextViewText(message, clear: true)
    }
    
    @IBAction func onFileTest() {
        self.startMeasure()
        self.fileTestCase.loadData(self.file)
        self.stopMeasure("File loading test")
        
        self.updateTextViewText(self.fileTestCase.largestAndSmallest() + "\n")
        self.updateTextViewText(self.fileTestCase.avgReading() + "\n")
        self.updateTextViewText(self.fileTestCase.groupedSensors() + "\n")
        
        self.fileTestRan = true
    }
    
    @IBAction func onSQLiteTest() {
        if (!self.fileTestRan) {
            self.updateTextViewText("You need to run file test first", clear: true)
            return
        }
        
        self.startMeasure()
        self.sqliteTestCase.loadData(sensors: self.fileTestCase.sensorsData, readings: self.fileTestCase.readingsData)
        self.stopMeasure("SQLite loading test")
        
        self.updateTextViewText(self.sqliteTestCase.largestAndSmallest() + "\n")
        self.updateTextViewText(self.sqliteTestCase.avgReading() + "\n")
        self.updateTextViewText(self.sqliteTestCase.groupedSensors() + "\n")
        
        self.sqliteTestCase.closeDb()
    }
    
    @IBAction func onCoreDataTest() {
        if (!self.fileTestRan) {
            self.updateTextViewText("You need to run file test first", clear: true)
            return
        }
        
        self.startMeasure()
        self.coreDataTestCase.loadData(sensors: self.fileTestCase.sensorsData, readings: self.fileTestCase.readingsData)
        self.stopMeasure("Core Data loading test")
        
        self.updateTextViewText(self.coreDataTestCase.largestAndSmallest() + "\n")
        self.updateTextViewText(self.coreDataTestCase.avgReading() + "\n")
        self.updateTextViewText(self.coreDataTestCase.groupedSensors() + "\n")
    }
}

