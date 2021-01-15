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
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.updateTextViewAsync(taskIdentifier: downloadTask.taskIdentifier, message: "Finished")
        
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("image-\(downloadTask.taskIdentifier).jpg")
        
        if FileManager.default.fileExists(atPath: destinationUrl.relativeString) {
            try! FileManager.default.removeItem(at: location)
        }
        
        try! FileManager.default.copyItem(at: location, to: destinationUrl)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float.init(totalBytesWritten) / Float.init(totalBytesExpectedToWrite)
        
        self.updateTextViewAsync(taskIdentifier: downloadTask.taskIdentifier, message: "Progress \(progress)")
    }
}

