//
//  SQLiteConnection.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/27.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import Foundation


class SQLiteConnection {
  
  var db :OpaquePointer? = nil
  let sqlitePath :String
  
  init?(path :String) {
    sqlitePath = path
    db = self.openDatabase(sqlitePath)
    if db == nil {
      return nil
    }
  }
  
  /// 连接数据库
  ///
  /// - Parameter path: 数据库目录
  /// - Returns: db
  func openDatabase(_ path :String) -> OpaquePointer? {
    var connectdb: OpaquePointer? = nil
    if sqlite3_open(path, &connectdb) == SQLITE_OK {
      print("成功连接数据库 ， path: \(path)")
      return connectdb
    } else {
      print("连接数据库失败")
      return nil
    }
  }
  
  
  /// 创建表
  ///
  /// - Parameters:
  ///   - tableName: 表名称
  ///   - columnsInfo: 列信息
  /// - Returns: Bool
  func createTable(_ tableName :String, columnsInfo :[String]) -> Bool {
    let sql = "create table if not exists \(tableName) "
      + "(\(columnsInfo.joined(separator: ",") ))"
    
    if sqlite3_exec(
      self.db, (sql as NSString).utf8String , nil, nil, nil) == SQLITE_OK{
      return true
    }
    return false
  }
  
  
  
  /// 新增数据
  ///
  /// - Parameters:
  ///   - sql: sql
  /// - Returns: Bool
  func insert(_ sql: String) -> Bool {
    var statement :OpaquePointer? = nil
    let result = sqlite3_prepare_v2(
      self.db, (sql as NSString).utf8String , -1, &statement, nil)
    print(sql)
    print("insert result -> \(result)")
    if result == SQLITE_OK {
      if sqlite3_step(statement) == SQLITE_DONE {
        return true
      }
      sqlite3_finalize(statement)
    }
    return false
  }
  
  
  /// 查询
  ///
  /// - Parameter sql: sql语句
  /// - Returns: 结果指针
  func fetch(_ sql:String) -> OpaquePointer? {
    var statement :OpaquePointer? = nil
    sqlite3_prepare_v2(
      self.db, (sql as NSString).utf8String , -1,
      &statement, nil)
    return statement
  }
  
  // 更新资料
  func update(
    tableName :String,
    cond :String?, rowInfo :[String:String]) -> Bool {
    var statement :OpaquePointer? = nil
    var sql = "update \(tableName) set "
    // row info
    var info :[String] = []
    for (k, v) in rowInfo {
      info.append("\(k) = \(v)")
    }
    sql += info.joined(separator: ",")
    
    // condition
    if let condition = cond {
      sql += " where \(condition)"
    }
    
    if sqlite3_prepare_v2(
      self.db, (sql as NSString).utf8String , -1 ,
      &statement, nil) == SQLITE_OK {
      if sqlite3_step(statement) == SQLITE_DONE {
        return true
      }
      sqlite3_finalize(statement)
    }
    return false
  }
  
  // 刪除资料
  func delete(_ tableName :String, cond :String?) -> Bool {
    var statement :OpaquePointer? = nil
    var sql = "delete from \(tableName)"
    
    // condition
    if let condition = cond {
      sql += " where \(condition)"
    }
    if sqlite3_prepare_v2(
      self.db, (sql as NSString).utf8String , -1,
      &statement, nil) == SQLITE_OK {
      if sqlite3_step(statement) == SQLITE_DONE {
        return true
      }
      sqlite3_finalize(statement)
    }
    return false
  }
  
  
  
  /// 已存在的表 添加新列
  ///
  /// - Parameters:
  ///   - tableName: 表名
  ///   - column: 列名
  /// - Returns: Bool
  func alter( _ tableName: String , column:String) -> Bool{
    let sql = "ALTER TABLE \(tableName) ADD COLUMN COLNew \(column)"
    
    if sqlite3_exec(
      self.db, (sql as NSString).utf8String , nil, nil, nil) == SQLITE_OK{
      return true
    }
    return false
  }
  
  
  /// 判断表是否存在
  ///
  /// - Parameter tableName: 表名称
  /// - Returns: Bool
  func isExitsTable(_ tableName: String)->Bool{
    let sql = "select count(*) from sqlite_master where type = 'table' and name = '\(tableName)'"
    if sqlite3_exec(
      self.db, (sql as NSString).utf8String , nil, nil, nil) == SQLITE_OK{
      return true
    }
    return false
  }
  
  
  /// 删除表
  ///
  /// - Parameter tableName: 表名
  /// - Returns: bool
  func dropTable(_ tableName: String) -> Bool{
    let sql = "drop table \(tableName)"
    if sqlite3_exec(
      self.db, (sql as NSString).utf8String , nil, nil, nil) == SQLITE_OK{
      return true
    }
    return false
  }
  
}
