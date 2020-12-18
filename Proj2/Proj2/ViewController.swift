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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
        
        FileTestCase.run()
        
        self.stopMeasure("File test")
    }
    
    @IBAction func onSQLiteTest() {
        self.startMeasure()
        
        self.stopMeasure("SQLite test")
    }
    
    
    @IBAction func onCoreDataTest() {
        self.startMeasure()
        
        self.stopMeasure("Core Data test")
    }
}

