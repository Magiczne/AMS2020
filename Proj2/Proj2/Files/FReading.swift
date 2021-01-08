//
//  FReading.swift
//  Proj2
//
//  Created by Magiczne on 18/12/2020.
//

import Foundation

class FReading: Codable, Comparable {
    var timestamp: String
    var sensor_id: String
    var value: Float
    
    static func ==(lhs: FReading, rhs: FReading) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }
    
    static func <(lhs: FReading, rhs: FReading) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}

extension DateFormatter {
    static let readingFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        // 2020-02-02T04:43:05
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter
    }()
}
