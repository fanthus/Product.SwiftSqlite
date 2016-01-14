//
//  SqliteDriver.swift
//  SqliteLib
//
//  Created by xiushan.fan on 12/1/16.
//  Copyright © 2016年 Frank. All rights reserved.
//

import Foundation

class SqliteDriver  {
    var driver:COpaquePointer = nil;
    
    class func driverOfFilePath(filePath:String) -> (SqliteDriver,SqliteResult) {
        let fileManager:NSFileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(filePath) {
            fileManager.createFileAtPath(filePath, contents: nil, attributes: nil)
        }
        print("sqlite file path:" + filePath)
        let sqliteDriver:SqliteDriver = SqliteDriver()
        let sqliteResult:SqliteResult = SqliteResult()
        sqliteResult.sqliteResultCode = Int32.init(sqlite3_open(filePath.cStringUsingEncoding(NSUTF8StringEncoding)!, &(sqliteDriver.driver)))
        return (sqliteDriver,sqliteResult)
    }
    
    func excuteSql(sql:String) -> SqliteResult {
        let result:SqliteResult = SqliteResult();
        let errmsg:UnsafeMutablePointer<UnsafeMutablePointer<Int8>> = nil;
        result.sqliteResultCode = sqlite3_exec(driver, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, nil, nil, errmsg)
        return result;
    }
    
    func excuteParam(param:SqliteParam) -> SqliteResult {
        if (param.bindArray.count == 0) {
            return self.excuteSql(param.sql!)
        }
        else {
            var compiledStatement:COpaquePointer = nil
            let result:SqliteResult = SqliteResult()
            result.sqliteResultCode = sqlite3_prepare(self.driver, (param.sql?.cStringUsingEncoding(NSUTF8StringEncoding))!, -1, &compiledStatement, nil)
            SQLITE_OK
            for (index,object) in (param.bindArray.enumerate()) {
                print("\(index) + \(object)")
                result.sqliteResultCode = sqlite3_bind_text(compiledStatement, Int32.init(index+1), (String.init(object) as! NSString).UTF8String, -1, nil)
            }
            result.sqliteResultCode = sqlite3_step(compiledStatement)
            sqlite3_reset(compiledStatement)
            return result
        }
    }
    
    func selectParam(param:SqliteParam) -> SqliteResult {
        var compiledStatement:COpaquePointer = nil
        let sqliteResult:SqliteResult = SqliteResult();
        sqlite3_prepare(driver, (param.sql?.cStringUsingEncoding(NSUTF8StringEncoding))!, -1, &compiledStatement, nil)
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            var rawDict:Dictionary<String,String> = Dictionary()
            for var i:Int32 = 0; i < sqlite3_column_count(compiledStatement); i++ {
                let columnName:UnsafePointer<Int8> = sqlite3_column_name(compiledStatement, i)
                let columnValue:UnsafePointer<UInt8> = sqlite3_column_text(compiledStatement, i)
                if columnValue != nil {
                    let name:COpaquePointer = COpaquePointer.init(columnName)
                    let value:COpaquePointer = COpaquePointer.init(columnValue)
                    rawDict[String.init(UTF8String: UnsafePointer.init(name))!] = String.init(UTF8String: UnsafePointer.init(value))
                    sqliteResult.sqliteResultData.append(rawDict)
                }
            }
        }
        return sqliteResult
    }
    
}
