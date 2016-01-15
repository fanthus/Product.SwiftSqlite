//
//  Fan.swift
//  SqliteLib
//
//  Created by xiushan.fan on 12/1/16.
//  Copyright © 2016年 Frank. All rights reserved.
//

import Foundation

class Fan {
    var id:Int?;
    var name:String?;
    
    class func driverOfTableFan() -> SqliteDriver {
        let paths:Array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        let documentPath:String = paths[0]
        let filePath:String = documentPath + "/fan.db"
        let driver = SqliteDriver.driverOfFilePath(filePath, tableName: "fan")
        if driver.tableExist("fan") == false {
            let param:SqliteParam = SqlitePrepare.createSqlWithTableName("fan", fieldArray: self.createTableFieldArray())
            driver.excuteParam(param)
        }
        return driver
    }
    
    class func createTableFieldArray() -> Array<String> {
        let filedArray:Array<String> = ["id integer","name text"]
        return filedArray;
    }
    
    func dictOfTableRow() -> [String:AnyObject] {
        var dict:[String:AnyObject] = [String:AnyObject]()
        dict["id"] =  NSNumber.init(long: self.id!)
        dict["name"] = self.name!
        return dict
    }
    
    class func dataOfDict(dataDict:Dictionary<String,String>) -> Fan {
        var fan:Fan = Fan()
        fan.id = Int.init(dataDict["id"]!)
        fan.name = dataDict["name"];
        return fan;
    }
}
