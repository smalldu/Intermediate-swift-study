//
//  Controller+swizzle.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/26.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

struct SwizzleHelper{
  // swizzle
  static func changeMethod(_ original:Selector,_ swizzled:Selector,_ object: AnyClass) -> () {
    let originalMethod = class_getInstanceMethod(object, original)
    let swizzledMethod = class_getInstanceMethod(object, swizzled)
    let didAddMethod: Bool = class_addMethod(object, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    if didAddMethod {
      class_replaceMethod(object, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod)
    }
  }
}

extension DispatchQueue {
  private static var onceTracker = [String]()
  open class func once(token: String, block:() -> Void) {
    objc_sync_enter(self)
    defer { objc_sync_exit(self) }
    if onceTracker.contains(token) {
      return
    }
    onceTracker.append(token)
    block()
  }
}


extension UIViewController {
  struct Static {
    static let token = NSUUID().uuidString
  }
  
  class func zz_swizzleAppear() {
    DispatchQueue.once(token: Static.token) {
      let willAppearSelector = #selector(UIViewController.viewWillAppear(_:) )
      let swizzleWillAppearSelector = #selector(UIViewController.zz_viewWillAppear(_:))
      SwizzleHelper.changeMethod(willAppearSelector, swizzleWillAppearSelector, self)
      
      let willDisappearSelector = #selector( UIViewController.viewWillDisappear(_:) )
      let swizzleWillDisAppearSelector = #selector(UIViewController.zz_viewWillDisappear(_:))
      SwizzleHelper.changeMethod(willDisappearSelector, swizzleWillDisAppearSelector, self)
      
      let presentVC = #selector( UIViewController.present(_:animated:completion:) )
      let s_presntVC = #selector( UIViewController.zz_present(_:animated:completion:) )
      SwizzleHelper.changeMethod(presentVC, s_presntVC, self)
    }
  }
  
  func zz_viewWillAppear(_ animated:Bool) {
    
    if !self.isKind(of: UINavigationController.self) && !self.isKind(of: UITabBarController.self) {
      Record.record(RecordType.enter , currentVC: self, nextVC: nil)
    }
    self.zz_viewWillAppear(animated)
  }
  
  func zz_viewWillDisappear(_ animated:Bool){
    if !self.isKind(of: UINavigationController.self) && !self.isKind(of: UITabBarController.self) {
      Record.record(RecordType.exit , currentVC: self, nextVC: nil)
    }
    self.zz_viewWillAppear(animated)
  }
  
  func zz_present( _ viewControllerToPresent: UIViewController, animated: Bool , completion: (()->Void)? ){
    Record.record(RecordType.jump , currentVC: self, nextVC: viewControllerToPresent)
    self.zz_present(viewControllerToPresent, animated: animated, completion: completion)
  }
}

extension UINavigationController {
  struct StaticNav {
    static let token = NSUUID().uuidString
  }
  static func zz_swizzlePushPop() {
    DispatchQueue.once(token: StaticNav.token) {
      let pushSelector = #selector(UINavigationController.pushViewController(_:animated:) )
      let popSelector = #selector(UINavigationController.popViewController(animated:))
      
      let swizzlePushSelector = #selector(UINavigationController.zz_pushViewController(_:animated:) )
      SwizzleHelper.changeMethod(pushSelector, swizzlePushSelector, self)
      let swizzlePopSelector = #selector(UINavigationController.zz_popViewController(animated:) )
      SwizzleHelper.changeMethod(popSelector, swizzlePopSelector, self)
    }
  }
  
  func zz_pushViewController(_ viewController: UIViewController, animated: Bool){
    if let vc = self.visibleViewController {
      Record.record(RecordType.jump , currentVC: vc, nextVC: viewController)
    }
    self.zz_pushViewController(viewController, animated: animated)
  }
  
  func zz_popViewController(animated: Bool) -> UIViewController?{
    let vc = self.zz_popViewController(animated: animated)
    if let vc = self.visibleViewController {
      Record.record(RecordType.jump , currentVC: vc, preVC: vc )
    }
    return vc
  }
}
