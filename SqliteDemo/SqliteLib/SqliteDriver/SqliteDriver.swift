//
//  SqliteDriver.swift
//  SqliteLib
//
//  Created by xiushan.fan on 12/1/16.
//  Copyright © 2016年 Frank. All rights reserved.
//

import Foundation

class SqliteDriver  {
    var dbHandler:COpaquePointer = nil;
    let sqliteMasterName:String = "sqlite_master"
    
    struct DbHandlerDictStruct {
        //class did not support dictionnary variable.so make a struct.
        static var onceToken:dispatch_once_t  = 0
        //This dict store the table with dbPath and dbhandler
        //The key is table with dbFilePath to make the dbHandler unique to table.
        static var dbTableDict:Dictionary<String,SqliteDriver>? = nil
    }
    
    class func driverOfFilePath(filePath:String, tableName:String) -> SqliteDriver {
        dispatch_once(&DbHandlerDictStruct.onceToken) { () -> Void in
            DbHandlerDictStruct.dbTableDict = Dictionary()
        }
        let dbHandlerKey:String = (filePath as NSString).stringByAppendingPathExtension(tableName)!
        if DbHandlerDictStruct.dbTableDict![dbHandlerKey] == nil {
            let sqliteDriver:SqliteDriver = SqliteDriver()
            let fileManager:NSFileManager = NSFileManager.defaultManager()
            if !fileManager.fileExistsAtPath(filePath) {
                fileManager.createFileAtPath(filePath, contents: nil, attributes: nil)
            }
            let sqliteResult:SqliteResult = SqliteResult()
            sqliteResult.sqliteResultCode = sqlite3_open(filePath.cStringUsingEncoding(NSUTF8StringEncoding)!, &sqliteDriver.dbHandler);
            DbHandlerDictStruct.dbTableDict![dbHandlerKey] = sqliteDriver;
            return sqliteDriver;
        }
        else {
            return DbHandlerDictStruct.dbTableDict![dbHandlerKey]!
        }
    }
    
    func excuteSql(sql:String) -> SqliteResult {
        let result:SqliteResult = SqliteResult();
        let errmsg:UnsafeMutablePointer<UnsafeMutablePointer<Int8>> = nil;
        result.sqliteResultCode = sqlite3_exec(dbHandler, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, nil, nil, errmsg)
        return result;
    }
    
    func excuteParam(param:SqliteParam) -> SqliteResult {
        if (param.bindArray.count == 0) {
            return self.excuteSql(param.sql!)
        }
        else {
            var compiledStatement:COpaquePointer = nil
            let result:SqliteResult = SqliteResult()
            result.sqliteResultCode = sqlite3_prepare(dbHandler, (param.sql?.cStringUsingEncoding(NSUTF8StringEncoding))!, -1, &compiledStatement, nil)
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
        sqlite3_prepare(dbHandler, (param.sql?.cStringUsingEncoding(NSUTF8StringEncoding))!, -1, &compiledStatement, nil)
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
    
    func tableExist(tableName:String) -> Bool {
        var result:SqliteResult = SqliteResult()
        let param:SqliteParam = SqlitePrepare.selectSqlWithTableName(sqliteMasterName, fieldArray: nil, condition: "type like 'table'")
        result = self.selectParam(param)
        let resultArray:Array<AnyObject> = result.sqliteResultData
        var found:Bool = false
        for var i:Int = 0;i < resultArray.count;i++  {
            let dict:Dictionary<String,String> = resultArray[i] as! Dictionary<String,String>
            let sqliteMasterModel:SqliteMasterModel = SqliteMasterModel.masterModelFromDict(dict)
            if (sqliteMasterModel.name! as NSString).isEqualToString(tableName) {
                found = true
                break;
            }
        }
        return found;
     }
}
