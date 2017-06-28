//
//  RecordDbManager.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/27.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


class RecordDbManager{
  
  static let shared:RecordDbManager = RecordDbManager()
  let sqlitePath = NSHomeDirectory() + "/Documents/sqlite3.db"
  var db: SQLiteConnection?
  var isCreateTableSuccess: Bool = false
  private let serialQueue = DispatchQueue(label: "zuber.im.record.manager", qos: DispatchQoS.background)
  private let tableName = "record"
  fileprivate var tmpRecords: [Record] = []
  private init(){
    serialQueue.async {
      self.db = SQLiteConnection(path: self.sqlitePath)
      if let myDb = self.db {
        
        let isExistTable = myDb.isExitsTable(self.tableName)
        if isExistTable {
          // 已经包含table
          
          // 新版加入字段 time_stamp
          if self.isExistCol("time_stamp") {
            // 包含此字段 已经添加过 
            self.isCreateTableSuccess = true
            self.uploadFile()
          }else{
            // 先处理上传数据
            self.uploadFile()
            
            // TODO: 下面事件应在上传完成回调中处理
            
            // 不包含 删除后重新创建
            let b = myDb.dropTable(self.tableName)
            if b {
              self.createTable()
            }
          }
        }else{
          // 不存在表 直接创建
          self.createTable()
        }
      }
    }
  }
  
  func register(){
  }
  
  func uploadFile(){
    do{
      let url = URL(fileURLWithPath: sqlitePath)
      let data = try Data(contentsOf: url)
      print(data)
      // 上传至后台
      
      
      self.queryAll() // 查询所有
      self.deleteAll() // 清空所有
    }catch let err {
      print(err.localizedDescription)
    }
  }
  
  /// 创建表
  func createTable(){
    guard let myDb = self.db else {
      return
    }
    // 创建表
    self.isCreateTableSuccess = myDb.createTable(self.tableName, columnsInfo: [
      "id integer primary key autoincrement" ,
      "uid text " ,
      "version text" ,
      "platform text" ,
      "device_id text" ,
      "cur_page text" ,
      "cur_page_title text" ,
      "pre_page text" ,
      "pre_page_title text" ,
      "next_page text" ,
      "next_page_title text" ,
      "operation text" ,
      "operation_identity text" ,
      "operation_value text" ,
      "create_time text" ,
      "time_stamp text " ,
      "remark text" ,
      "ext1 text" ,
      "ext2 text" ,
      ])
    
    if self.isCreateTableSuccess {
      // 创建成功 将临时变量数据存储
      print("将临时变量数据存储")
      for item in tmpRecords {
        self.insert(item)
      }
      // 删除临时数据
      tmpRecords.removeAll()
    }
    
  }
  
  /// 新增数据
  ///
  /// - Parameter record:
  func insert( _ record:Record ) {
    if !isCreateTableSuccess {
      // 保存临时变量中
      tmpRecords.append(record)
      print("--保存临时 \(record.operation )")
      return
    }
    serialQueue.async {
      let sql = "insert into \(self.tableName) (uid,version,platform,device_id,cur_page,cur_page_title,pre_page,pre_page_title,next_page,next_page_title,operation,operation_identity,operation_value,create_time , time_stamp,remark,ext1,ext2) "
        + " values "
        + " ( '\(record.uid)','\(record.version)','\(record.platform)','\(record.device_id)','\(record.cur_page)','\(record.cur_page_title)','\(record.pre_page)','\(record.pre_page_title)','\(record.next_page)','\(record.next_page_title)','\(record.operation)','\(record.operation_identity)','\(record.operation_value)','\(record.create_time)' , '\(record.time_stamp)' ,'\(record.remark)', '\(record.ext1)', '\(record.ext2)' ) "
      _ = self.db?.insert(sql)
    }
  }
  
  
  /// 删除所有数据
  func deleteAll (){
    if !isCreateTableSuccess {
      return
    }
    serialQueue.async {
      _ = self.db?.delete(self.tableName, cond: nil)
    }
  }
  
  
  /// 是否包含某列
  ///
  /// - Parameter colName: 列名
  /// - Returns: Bool
  func isExistCol( _ colName:String )->Bool{
    guard let myDb = db else {
      return false
    }
    let sql = "PRAGMA table_info(\(self.tableName))"
    let statement = myDb.fetch(sql)
    while sqlite3_step(statement) == SQLITE_ROW{
//      let number = String(cString: sqlite3_column_text(statement, 0))
      let name = String(cString: sqlite3_column_text(statement, 1))
//      let style = String(cString: sqlite3_column_text(statement, 2))
      print("\(name) ---- \(colName)")
      if name == colName {
        return true
      }
    }
    return false
  }
  
  
  /// 查询所有数据
  func queryAll(){
    if !isCreateTableSuccess {
      return
    }
    guard let myDb = db else {
      return
    }
    let statement = myDb.fetch("select id,cur_page,cur_page_title,operation,operation_identity,operation_value,create_time from \(self.tableName)")
    while sqlite3_step(statement) == SQLITE_ROW{
      let id = sqlite3_column_int(statement, 0)
      let cur_page = String(cString: sqlite3_column_text(statement, 1))
      let cur_page_title = String(cString: sqlite3_column_text(statement, 2))
      let operation = String(cString: sqlite3_column_text(statement, 3))
      let operation_identity = String(cString: sqlite3_column_text(statement, 4))
      let operation_value = String(cString: sqlite3_column_text(statement, 5))
      let create_time = String(cString: sqlite3_column_text(statement, 6))
      print("id:\(id) , cur_page:\(cur_page), cur_page_title:\(cur_page_title), operation:\(operation), operation_identity:\(operation_identity), operation_value:\(operation_value),create_time:\(create_time)")
    }
    sqlite3_finalize(statement)

  }
}

