//
//  SqliteParam.swift
//  SqliteLib
//
//  Created by xiushan.fan on 12/1/16.
//  Copyright © 2016年 Frank. All rights reserved.
//

import Foundation

class SqliteParam  {
    var sql:String?
    var bindArray:Array<AnyObject> = Array()
    
    func description() -> String {
        return "hello world.....param"
    }
}
