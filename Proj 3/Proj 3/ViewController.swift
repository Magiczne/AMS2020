//
//  ViewController.swift
//  Proj 3
//
//  Created by Magiczne on 15/01/2021.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate, URLSessionTaskDelegate {
    @IBOutlet weak var textView: UITextView!
    
    var images: [String] = [
        "https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/0/06/Master_of_Fl%C3%A9malle_-_Portrait_of_a_Fat_Man_-_Google_Art_Project_(331318).jpg",
        "https://upload.wikimedia.org/wikipedia/commons/c/ce/Petrus_Christus_-_Portrait_of_a_Young_Woman_-_Google_Art_Project.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/c/c8/Valmy_Battle_painting.jpg"
    ]
    
    var progress: [Int:Int] = [:]
    
    func updateTextViewAsync (taskIdentifier: Int, message: String) {
        DispatchQueue.main.async {
            let msg = "[Task \(taskIdentifier)] - \(message)"
            
            self.textView.text = "\(self.textView.text ?? "")\n\(msg)"
        }
    }
    
    @IBAction func onButtonClick(_ sender: Any) {
        let session: URLSession = {
            let config = URLSessionConfiguration.background(withIdentifier: "com.magiczne.proj3")
            
            return URLSession(configuration: config, delegate: self, delegateQueue: nil)
        }()
        
        for image in self.images {
            let task = session.downloadTask(with: URL(string: image)!)
            
            self.progress[task.taskIdentifier] = 0
            
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.updateTextViewAsync(taskIdentifier: downloadTask.taskIdentifier, message: "Finished")
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("image-\(downloadTask.taskIdentifier).jpg")
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            try! FileManager.default.removeItem(atPath: destinationUrl.path)
        } else {
            print("\(destinationUrl.path) does not exist")
        }
        
        if FileManager.default.fileExists(atPath: location.path) {
            try! FileManager.default.copyItem(atPath: location.path, toPath: destinationUrl.path)
        } else {
            print("\(location.path) does not exist")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Int((Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)) * 100)
        
        if progress / 10 > self.progress[downloadTask.taskIdentifier]! {
            self.updateTextViewAsync(taskIdentifier: downloadTask.taskIdentifier, message: "Progress \(progress / 10 * 10)%")
            self.progress[downloadTask.taskIdentifier] = Int(progress / 10)
        }
    }
}

