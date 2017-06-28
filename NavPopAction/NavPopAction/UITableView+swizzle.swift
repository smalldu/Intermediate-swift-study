//
//  UITableView+swizzle.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/26.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

/// 先 hook 住UITableView的delegate方法 然后找出其delegate ， 然后再hook住点击方法

extension UIViewController {
  func zz_tableView(_ tableView: UITableView,didSelectRowAt indexPath:IndexPath){
    Record.record(RecordType.tbCell , currentVC:self,view:tableView ,indexPath:indexPath)
    print(indexPath)
    self.zz_tableView(tableView, didSelectRowAt: indexPath)
  }
}

extension UITableView {

  struct TableStatic {
    static let token = NSUUID().uuidString
    static let delegate_token = NSUUID().uuidString
  }

  func zz_setDelegate(_ delegate:UITableViewDelegate?) {
    print("tb_delegate")
    if let delegate = delegate as? UIViewController{
      if delegate.responds(to: #selector( UITableViewDelegate.tableView(_:didSelectRowAt:))) {
        // HOOK 住代理的方法 这里只针对vc中的tableview代理进行埋点
        let originSelector = #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))
        let swizzleSelector = #selector(UIViewController.zz_tableView(_:didSelectRowAt:))
        SwizzleHelper.changeMethod(originSelector, swizzleSelector, delegate.classForCoder)
      }
    }
    self.zz_setDelegate(delegate)
  }
  
  
  class func zz_swizzleTableDidSelect() {
    DispatchQueue.once(token: TableStatic.token) {
      // 先 hook住系统delegate的 setter方法
      let addDelegate = #selector(setter: UITableView.delegate)
      let s_addDelegate = #selector(UITableView.zz_setDelegate(_:))
      SwizzleHelper.changeMethod(addDelegate, s_addDelegate, self)
    }
  }

}




