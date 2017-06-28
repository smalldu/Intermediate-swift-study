//
//  UIButton+swizzle.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/26.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


struct Swizzle{
  
  static let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
  
  static func currentDate() -> (String,String){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
    let date = Date(timeIntervalSinceNow: 0)
    let interval = date.timeIntervalSince1970
    return (dateFormatter.string(from: date),"\((interval*1000))")
  }
  
  
  
  static func register() {
    UIView.zz_swizzleGesture()
    UITableView.zz_swizzleTableDidSelect()
    UIButton.zz_swizzleSendAction()
    UIViewController.zz_swizzleAppear()
    UINavigationController.zz_swizzlePushPop()
  }
}

extension UIButton {
  
  struct Static {
    static let token = NSUUID().uuidString
  }
  
  class func zz_swizzleSendAction() {
    DispatchQueue.once(token: Static.token) {
      let clickSelector = #selector(UIButton.sendAction(_:to:for:) )
      let s_clickSelector = #selector(UIButton.zz_sendAction(_:to:forEvent:))
      SwizzleHelper.changeMethod(clickSelector, s_clickSelector, self)
    }
  }

  public  func zz_sendAction(_ action : Selector, to : AnyObject!, forEvent : UIEvent!) {
    let curvc = self.responderViewController()
    Record.record(RecordType.button , currentVC: curvc , view:self )
    self.zz_sendAction(action, to: to, forEvent: forEvent)
  }
}



extension UIView{
  struct ViewStatic {
    static let token = NSUUID().uuidString
  }
  
  class func zz_swizzleGesture() {
    DispatchQueue.once(token: ViewStatic.token) {
      let clickSelector = #selector(UIView.addGestureRecognizer(_:) )
      let s_clickSelector = #selector(UIView.zz_addGestureRecognizer(gestureRecognizer:) )
      SwizzleHelper.changeMethod(clickSelector, s_clickSelector, self)
    }
  }
  
  func zz_addGestureRecognizer(gestureRecognizer:UIGestureRecognizer){
    if let gestureRecognizer = gestureRecognizer as? UITapGestureRecognizer{
      gestureRecognizer.addTarget(self, action: #selector(UIView.zz_tapGestureRecognizer(gesture:)))
    }
    self.zz_addGestureRecognizer(gestureRecognizer: gestureRecognizer)
  }
  
  func zz_tapGestureRecognizer(gesture:UITapGestureRecognizer){
    let curvc = self.responderViewController()
    Record.record(RecordType.tap, currentVC: curvc , view:self)
  }
  
  
  //查找vc
  func responderViewController() -> UIViewController {
    var responder: UIResponder! = nil
    var next = self.superview
    while next != nil {
      responder = next?.next
      if (responder!.isKind(of: UIViewController.self)){
        return (responder as! UIViewController)
      }
      next = next?.superview
    }
    return (responder as! UIViewController)
  }
  
}



