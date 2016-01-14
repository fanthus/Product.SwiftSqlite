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
