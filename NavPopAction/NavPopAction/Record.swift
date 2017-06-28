//
//  Record.swift
//  NavPopAction
//  行为统计记录
//  Created by duzhe on 2017/6/27.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

enum RecordType: String {
  case enter = "进入页面"
  case exit = "离开页面"
  case jump = "跳转页面"
  case button = "按钮"
  case tbCell = "点击table cell"
  case colCell = "点击collection cell"
  case tap = "tap"
}

struct Record {
  
  var id: Int = 0  // 主键 自增
  var uid:String = ""
  var version: String = ""
  var platform: String = ""
  var device_id: String = ""
  var cur_page: String = ""  // 当前页面
  var cur_page_title: String = "" // 当前页面标题
  var pre_page: String = ""
  var pre_page_title: String = ""
  var next_page: String = ""
  var next_page_title: String = ""
  var operation: String = ""  // 进入、离开、跳转 、按钮 、 tableview cell 、 collectionview cell 、 tap  (可添加)
  var operation_identity: String = ""
  var operation_value: String = ""
  var create_time: String = ""
  var time_stamp: String = ""
  var remark: String = ""
  var ext1: String = ""
  var ext2: String = ""
  
  static func record(_ type:RecordType,currentVC:UIViewController , nextVC:UIViewController? = nil, preVC:UIViewController? = nil , view:UIView? = nil , indexPath:IndexPath? = nil) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background ).async {
      let currentMirror:Mirror = Mirror(reflecting: currentVC)
      if "\(currentMirror.subjectType)" == "UICompatibilityInputViewController" || "\(currentMirror.subjectType)" == "UIInputWindowController"{
        return
      }
      var record = Record()
      record.uid = "78"
      record.cur_page = "\(currentMirror.subjectType)"
      let time = Swizzle.currentDate()
      record.create_time = time.0
      record.time_stamp = time.1
      record.cur_page_title = currentVC.title ?? ""
      
      if let nextVC = nextVC {
        let nextMirror:Mirror = Mirror(reflecting: nextVC)
        record.next_page = "\(nextMirror.subjectType)"
        record.next_page_title = nextVC.title ?? ""
      }
      
      if let preVC = preVC {
        let preMirror:Mirror = Mirror(reflecting: preVC)
        record.pre_page = "\(preMirror.subjectType)"
        record.pre_page_title = preVC.title ?? ""
      }
      
      if let btn = view as? UIButton {
        let btnMirror:Mirror = Mirror(reflecting: btn)
        record.operation_identity = "\(currentMirror.subjectType)_\(btnMirror.subjectType)"
        record.operation_value = "\(currentVC.title ?? "")_\(btn.titleLabel?.text ?? "")"
      }else if let tb = view as? UITableView {
        if let indexPath = indexPath{
          if let cell = tb.cellForRow(at: indexPath) {
            let cellMirror = Mirror(reflecting: cell)
            record.operation_identity = "\(currentMirror.subjectType)_tb_\(cellMirror.subjectType)"
            record.operation_value = "\(currentVC.title ?? "")_tb_section_\(indexPath.section)_row_\(indexPath.row)"
          }
        }
      }else if let view = view {
        if type == .tap {
          let viewMirror:Mirror = Mirror(reflecting: view)
          record.operation_identity = "\(currentMirror.subjectType)_\(viewMirror.subjectType)"
          record.operation_value = "\(currentVC.title ?? "")_\(viewMirror.subjectType)_taped"
        }
      }
      record.operation = type.rawValue
      record.platform = "ios"
      RecordDbManager.shared.insert(record)
    }
  }
  
}
