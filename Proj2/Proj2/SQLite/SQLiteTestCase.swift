//
//  SQLiteTestCase.swift
//  Proj2
//
//  Created by Magiczne on 05/01/2021.
//

import Foundation

class SQLiteTestCase {
    var db: OpaquePointer? = nil
    
    func loadData (sensors: [FSensor], readings: [FReading]) {
        let fileUrl = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("database.sqlite")
        
        if sqlite3_open(fileUrl.path, &self.db) != SQLITE_OK {
            print("DB not Working")
            return
        }
        
        let createSensorsSql = """
            CREATE TABLE IF NOT EXISTS sensors (
                id VARCHAR(10) PRIMARY KEY,
                description VARCHAR(50)
            );
        """
        
        let createReadingsSql = """
            CREATE TABLE IF NOT EXISTS readings (
                timestamp VARCHAR(50),
                sensor_id VARCHAR(10),
                value REAL,
                FOREIGN KEY(sensor_id) REFERENCES sensors(id)
            )
        """
        
        sqlite3_exec(self.db, createSensorsSql, nil, nil, nil)
        sqlite3_exec(self.db, createReadingsSql, nil, nil, nil)
        sqlite3_exec(self.db, "DELETE FROM sensors", nil, nil, nil)
        sqlite3_exec(self.db, "DELETE FROM readings", nil, nil, nil)
        
        sqlite3_exec(self.db, "BEGIN TRANSACTION;", nil, nil, nil)
        
        var query = "INSERT INTO sensors VALUES(?,?);"
        var stmt: OpaquePointer? = nil
        
        // Sensors data
        if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) != SQLITE_OK {
            print("Not working")
        }
        
        for elem in sensors {
            sqlite3_bind_text(stmt, 1, (elem.id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (elem.description as NSString).utf8String, -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                NSLog("Error %s", sqlite3_errmsg(db))
                
                sqlite3_finalize(stmt)
            }
            
            sqlite3_reset(stmt)
        }
        
        sqlite3_finalize(stmt)
        
        // Readings data
        query = "INSERT INTO readings VALUES(?, ?, ?)"
        
        if sqlite3_prepare_v2(self.db, query, -1, &stmt, nil) != SQLITE_OK {
            print("Not working")
        }
        
        for elem in readings {
            sqlite3_bind_text(stmt, 1, (elem.timestamp as NSString).utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, (elem.sensor_id as NSString).utf8String, -1, nil)
            sqlite3_bind_double(stmt, 3, Double.init(elem.value))
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                NSLog("Error %s", sqlite3_errmsg(self.db))
                
                sqlite3_finalize(stmt)
            }
            
            sqlite3_reset(stmt)
        }
        
        sqlite3_finalize(stmt)
        
        sqlite3_exec(self.db, "COMMIT TRANSACTION;", nil, nil, nil);
    }
    
    func closeDb() {
        sqlite3_close(self.db)
        self.db = nil
    }
    
    func runTests() {
        //        var stmt: OpaquePointer? = nil
        //        let selectSQL = "SELECT id, description FROM sensors;"
        //        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
        //
        //        while sqlite3_step(stmt) == SQLITE_ROW {
        //            let id = String(cString: sqlite3_column_text(stmt, 0))
        //            let desc = String(cString: sqlite3_column_text(stmt, 1))
        //
        //            print("Sensor id = \(id), desc = \(desc)")
        //        }
        //
        //        sqlite3_finalize(stmt)
                
    }
    
    func largestAndSmallest () -> String {
        var smallest = ""
        var largest = ""
        var stmt: OpaquePointer? = nil
        
        // Smallest
        var select = "SELECT timestamp FROM readings ORDER BY timestamp ASC;"
        sqlite3_prepare_v2(self.db, select, -1, &stmt, nil)
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            largest = String(cString: sqlite3_column_text(stmt, 0))
        }
        sqlite3_finalize(stmt)
        
        // Largest
        select = "SELECT timestamp FROM readings ORDER BY timestamp DESC;"
        sqlite3_prepare_v2(self.db, select, -1, &stmt, nil)
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            smallest = String(cString: sqlite3_column_text(stmt, 0))
        }
        sqlite3_finalize(stmt)
        
        return """
        Smallest: \(smallest)
        Largest: \(largest)
        """
    }
    
    func avgReading () -> String {
        var stmt: OpaquePointer? = nil
        let select = "SELECT AVG(value) FROM readings;"
        sqlite3_prepare_v2(self.db, select, -1, &stmt, nil)
        
        var msg = ""
        while sqlite3_step(stmt) == SQLITE_ROW {
            let avg = sqlite3_column_double(stmt, 0)
            
            msg = "Average: \(avg)"
        }
        sqlite3_finalize(stmt)
        
        return msg
    }
    
    func groupedSensors () -> String {
        var stmt: OpaquePointer? = nil
        let select = "SELECT sensor_id, AVG(value), COUNT(value) FROM readings GROUP BY sensor_id;"
        sqlite3_prepare_v2(self.db, select, -1, &stmt, nil)
        
        var msg = ""
        while sqlite3_step(stmt) == SQLITE_ROW {
            let sensor = String(cString: sqlite3_column_text(stmt, 0))
            let avg = sqlite3_column_double(stmt, 1)
            let count = sqlite3_column_int(stmt, 2)
            
            msg += "\(sensor) - Avg = \(avg), Count = \(count)\n"
        }
        sqlite3_finalize(stmt)
        
        return msg
    }
}
