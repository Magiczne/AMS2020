//
//  FReading.swift
//  Proj2
//
//  Created by Magiczne on 18/12/2020.
//

import Foundation

class FReading: Codable {
    var timestamp: Date
    var sensor_id: String
    var value: Float
}

extension DateFormatter {
    static let readingFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        // 2020-02-02T04:43:05
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }()
}
