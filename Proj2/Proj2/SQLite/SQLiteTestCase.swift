//
//  SQLiteTestCase.swift
//  Proj2
//
//  Created by Magiczne on 05/01/2021.
//

import Foundation

class SQLiteTestCase {
    static func run (_ readings: String) {
        let decoder = JSONDecoder()
        let fileUrl = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("database.sqlite")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fileUrl.path, &db) == SQLITE_OK {
            print("DB Working")
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
        
        sqlite3_exec(db, createSensorsSql, nil, nil, nil)
        sqlite3_exec(db, createReadingsSql, nil, nil, nil)
        sqlite3_exec(db, "DELETE FROM sensors", nil, nil, nil)
        sqlite3_exec(db, "DELETE FROM readings", nil, nil, nil)
        
        if let sensorsUrl = Bundle.main.url(forResource: "sensors", withExtension: "json") {
            do {
                let data = try Data(contentsOf: sensorsUrl)
                let jsonData = try decoder.decode([FSensor].self, from: data)
                
                let query = "INSERT INTO sensors VALUES(?,?);"
                var stmt: OpaquePointer? = nil
                
                if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
                    print("Not working")
                }
                
                for elem in jsonData {
                    sqlite3_bind_text(stmt, 1, (elem.id as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(stmt, 2, (elem.description as NSString).utf8String, -1, nil)
                    
                    if sqlite3_step(stmt) != SQLITE_DONE {
                        NSLog("Error %s", sqlite3_errmsg(db))
                        
                        sqlite3_finalize(stmt)
                    }
                    
                    sqlite3_reset(stmt)
                }
                
                sqlite3_finalize(stmt)
            } catch {
                print("Sensors error: \(error)")
            }
        }
        
        if let readingsUrl = Bundle.main.url(forResource: readings, withExtension: "json") {
            do {
                let data = try Data(contentsOf: readingsUrl)
                let jsonData = try decoder.decode([FReading].self, from: data)
                
                let query = "INSERT INTO readings VALUES(?, ?, ?)"
                var stmt: OpaquePointer? = nil
                
                if sqlite3_prepare_v2(db, query, -1, &stmt, nil) != SQLITE_OK {
                    print("Not working")
                }
                
                for elem in jsonData {
                    sqlite3_bind_text(stmt, 1, (elem.timestamp as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(stmt, 2, (elem.sensor_id as NSString).utf8String, -1, nil)
                    sqlite3_bind_double(stmt, 3, Double.init(elem.value))
                    
                    if sqlite3_step(stmt) != SQLITE_DONE {
                        NSLog("Error %s", sqlite3_errmsg(db))
                        
                        sqlite3_finalize(stmt)
                    }
                    
                    sqlite3_reset(stmt)
                }
                
                sqlite3_finalize(stmt)
            } catch {
                print("Readings error: \(error)")
            }
        }
        
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
        
        sqlite3_close(db)
        db = nil
    }
}
