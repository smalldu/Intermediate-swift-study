//
//  ViewController.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
  
  @IBOutlet weak var demoLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "首页"
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
    demoLabel.isUserInteractionEnabled = true
    demoLabel.addGestureRecognizer(tap)
    
//    var db :OpaquePointer? = nil
//    // 数据库路径
//    let urls = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)
//    let sqlitePath = (urls.last?.absoluteString ?? "") + "sqlite3.db"
//    
//    
//    // 连接数据库
//    if sqlite3_open(sqlitePath, &db) == SQLITE_OK {
//      print("成功")
//      guard let db = db else {
//        return
//      }
//      // 新建一张 record 表
//      
//      let sql = "create table if not exists record ( id integer primary key autoincrement ,"
//        + "uid text ," // 当前用户
//        + "version text ," // 版本号
//        + "device_id text ," // 设备编号
//        + "cur_page text ," // 当前页面
//        + "cur_page_title text ," // 当前页标题
//        + "pre_page text ," // 前一个页面
//        + "pre_page_title text ," // 前一个页面标题
//        + "operation text ," // 操作  进入、离开、跳转 、点击 (可添加)
//        + "operation_identity text ," // 操作视图标识
//        + "operation_value text ," // 操作视图名称
//        + "create_time text ," // 时间
//        + "remark text " // 备注
//        + ")"
//      
//      if sqlite3_exec(db, (sql as NSString).utf8String , nil , nil , nil) == SQLITE_OK {
//        print("创建表成功")
//        
//        var statement :OpaquePointer? = nil
//        // 新增资料
//        let insertSql = "insert into record "
//          + "(uid,version,cur_page,create_time) "
//          + " values ( '78' , '1.2.3' , 'HomeViewController' , '\(Swizzle.currentDate())' )"
//        
//        print(insertSql)
////        第三個參數則是設定資料庫可以讀取的最大資料量，單位是位元組( Byte )，設為-1表示不限制讀取量
//        let result = sqlite3_prepare_v2(db , (insertSql as NSString).utf8String, -1, &statement, nil)
//        print(result)
//        if result == SQLITE_OK {
//          if let statement = statement {
//            if sqlite3_step(statement) == SQLITE_DONE {
//                print("新增资料成功")
//            }
//            sqlite3_finalize(statement) // 释放statement
//          }
//        }
//        
//        // 读取资料
//        var queryStatement :OpaquePointer? = nil
//        let querySql = "select * from record"
//        
//        sqlite3_prepare_v2(db,  (querySql as NSString).utf8String , -1 , &queryStatement , nil )
//        guard let qstatement = queryStatement else {
//          return
//        }
//        while sqlite3_step(qstatement) == SQLITE_ROW {
//          let id = sqlite3_column_int(qstatement, 0)
//          let uid = String(cString: sqlite3_column_text(qstatement, 1))
//          print("id:\(id) , uid:\(uid)")
//        }
//        sqlite3_finalize(queryStatement)
//        
//        
//        let Altersql = "ALTER TABLE record ADD COLUMN COLNew platform"
//        
//        if sqlite3_exec(
//          db, (Altersql as NSString).utf8String , nil, nil, nil) == SQLITE_OK{
//          
//          print("slter success")
//        }
//      }
//    }else{
//      print("失败")
//    }


    
    
    
  }
  
  func tapLabel(){
    print("taped!")
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}


