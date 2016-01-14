//
//  SqlitePrepare.swift
//  SqliteLib
//
//  Created by xiushan.fan on 12/1/16.
//  Copyright © 2016年 Frank. All rights reserved.
//

import Foundation

class SqlitePrepare  {
    class func createSqlWithTableName(tableName:String,fieldArray:Array<String>) -> SqliteParam {
        var fieldString:String = String()
        for field in fieldArray {
            fieldString.appendContentsOf("\(field),")
        }
        fieldString.removeAtIndex(fieldString.endIndex.predecessor())
        
        let param:SqliteParam = SqliteParam()
        param.sql = "create table if not exists \(tableName) (\(fieldString));";
        return param
    }
    
    class func insertSqlWithTableName(tableName:String,dict:[String:AnyObject]) -> SqliteParam {
        var fieldString:String = String()
        var placeHolderString:String = String()
        var bindArray:Array<AnyObject> = Array()
        
        for (key,object) in dict {
            fieldString.appendContentsOf("\(key),")
            placeHolderString.appendContentsOf("?,")
            bindArray.append(object)
        }
        fieldString.removeAtIndex(fieldString.endIndex.predecessor())
        placeHolderString.removeAtIndex(placeHolderString.endIndex.predecessor())
        let insertString:String = "insert into \(tableName)(\(fieldString)) values(\(placeHolderString));"
        let param:SqliteParam = SqliteParam()
        param.sql = insertString
        param.bindArray = bindArray
        return param
    }
    
    class func selectSqlWithTableName(tableName:String,fieldArray:Array<String>?,condition:String) -> SqliteParam {
        let param:SqliteParam = SqliteParam()
        var sql:String = String()
        if fieldArray == nil || fieldArray?.count == 0 {
            sql = "select * from \(tableName)"
        }
        else {
            var fieldString:String = String()
            for field in fieldArray! {
                fieldString.appendContentsOf("\(field),")
            }
            fieldString.removeAtIndex(fieldString.endIndex.predecessor())
            sql.appendContentsOf("select \(fieldString) from \(tableName)")
        }
        if condition.characters.count != 0 {
            sql.appendContentsOf(" where \(condition)")
        }
        param.sql = sql
        return param
    }
    
    
    
    
    class func updateSqlWithTableName(tableName:String,dict:Dictionary<String,AnyObject>,condition:String) -> SqliteParam {
        var setString:String = String()
        var bindArray:Array<AnyObject> = Array()
        for (key,value) in dict {
            setString.appendContentsOf("\(key)=?,")
            bindArray.append(value)
        }
        setString.removeAtIndex(setString.endIndex.predecessor())
        var updateSql:String = "update \(tableName) set \(setString)"
        if condition.characters.count > 0 {
            updateSql.appendContentsOf(" where \(condition)")
        }
        let param:SqliteParam = SqliteParam()
        param.sql = updateSql
        param.bindArray = bindArray
        return param
    } 
}