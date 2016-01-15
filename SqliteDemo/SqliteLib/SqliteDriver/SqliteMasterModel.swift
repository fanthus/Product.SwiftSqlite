//
//  SqliteMasterModel.swift
//  SqliteLib
//
//  Created by xiushan.fan on 12/1/16.
//  Copyright © 2016年 Frank. All rights reserved.
//

import Foundation

class SqliteMasterModel {
    var name:String?
    var rootPage:NSInteger = 0
    var sql:String?
    var tbl_name:String?
    var type:String?
    
    class func masterModelFromDict(dict:NSDictionary) -> SqliteMasterModel {
        let sqliteMasterModel:SqliteMasterModel = SqliteMasterModel()
        sqliteMasterModel.type = dict.objectForKey("type") as! String?
        sqliteMasterModel.name = dict.objectForKey("name") as! String?
        sqliteMasterModel.tbl_name = dict.objectForKey("tbl_name") as! String?
        sqliteMasterModel.rootPage = NSInteger.init((dict.objectForKey("rootpage") as! String?)!)!
        sqliteMasterModel.sql = dict.objectForKey("sql") as! String?
        return sqliteMasterModel
    }
}
