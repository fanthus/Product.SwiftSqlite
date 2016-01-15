//
//  ViewController.swift
//  SqliteLib
//
//  Created by xiushan.fan on 7/1/16.
//  Copyright © 2016年 Frank. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        let fan:Fan = Fan()
        fan.id = 1000;
        fan.name = "fanxiushan"
        
        let sqliteDriver = Fan.driverOfTableFan()
        
        //insert record.
        let insertParam:SqliteParam = SqlitePrepare.insertSqlWithTableName("fan", dict: fan.dictOfTableRow())
        print(insertParam.sql)
        let insertResult = sqliteDriver.excuteParam(insertParam)
        print(insertResult)
        //
        let selectParam:SqliteParam = SqlitePrepare.selectSqlWithTableName("fan", fieldArray: nil, condition: "")
        print(selectParam.sql)
        let selectResult:SqliteResult = sqliteDriver.selectParam(selectParam)
        
        print(selectResult)
        
        let dataArray:Array<AnyObject> = selectResult.sqliteResultData
        
        for var i:Int = 0;i < dataArray.count;i++ {
            var fan = Fan.dataOfDict(dataArray[i] as! Dictionary<String, String>)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

