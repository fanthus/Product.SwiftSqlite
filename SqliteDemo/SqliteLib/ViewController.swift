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
        print("dataArray \(dataArray)")
        
        fan.name = "hello world"
        let updateParam:SqliteParam = SqlitePrepare.updateSqlWithTableName("fan", dict: fan.dictOfTableRow(), condition: "id = 1000")
        let updateResult = sqliteDriver.excuteParam(updateParam)
        print("updateResult \(updateResult.sqliteResultCode)")
        
        let selectResult1:SqliteResult = sqliteDriver.selectParam(selectParam)
        let afterUpdateDataArray:Array<AnyObject> = selectResult1.sqliteResultData
        print("after update dataArray \(afterUpdateDataArray)")
        
        
        let deleteParam = SqlitePrepare.deleteSqlWithTableName("fan", condition: "id = 1000")
        sqliteDriver.excuteParam(deleteParam)
        let selectResult2:SqliteResult = sqliteDriver.selectParam(selectParam)
        let afterDeleteDataArray:Array<AnyObject> = selectResult2.sqliteResultData
        print("after delete dataArray \(afterDeleteDataArray)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

