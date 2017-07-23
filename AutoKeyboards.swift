//
//  ZZModules.swift
//  Swift_iOS_Module
//
//  Created by duzhe on 16/9/5.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

protocol  AutoKeyboards {
    
}

extension AutoKeyboards where Self:UIViewController {
    
    // 返回外部处理
    var backTap:UITapGestureRecognizer? {
        return AutoKey.shareInstance.tap
    }
    
    // 注册通知
    func registNotify(){
        AutoKey.shareInstance.view = self.view
        AutoKey.shareInstance.registNotify()
    }
    
    // 注销通知
    func resignNotify(){
        AutoKey.shareInstance.resignNotify()
    }
    
    // 注册tap
    func registTap(){
        AutoKey.shareInstance.registTap()
    }
}

class AutoKey: NSObject {
    var view:UIView!
    var tap:UITapGestureRecognizer?
    
    
    static var shareInstance:AutoKey = AutoKey()
    
    func registNotify(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyBoardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyBoardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func registTap(){
        tap = UITapGestureRecognizer(target: self, action:#selector(handleTouches(_:)))
        tap?.delegate = self
        self.view.addGestureRecognizer(tap!)
    }
    
    func handleTouches(sender:UITapGestureRecognizer){
        if sender.locationInView(self.view).y < self.view.bounds.height{
            UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
        }
    }
    
    func resignNotify(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyBoardWillShow(note:NSNotification)
    {
        guard let userInfo  = note.userInfo else { return }
        guard let window = UIApplication.sharedApplication().keyWindow else { return }
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        
        let currV = window.findFirstResponder()

        if let currV = currV as? UITextField{
            var p = self.view.convertPoint(currV.frame.origin , fromView: currV.superview )
            if p.y > 0{
                p.y = -1*p.y
            }
            
            //print((-deltaY+(self.view.frame.height + p.y - currV.frame.height - 20)))
            
            let animations:(() -> Void) = {
                self.view.transform = CGAffineTransformMakeTranslation(0,min((-deltaY+(self.view.frame.height + p.y - currV.frame.height - 20)),0))
            }
            
            if duration > 0 {
                let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
                UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            }else{
                animations()
            }
        }
    }
    
    func keyBoardWillHide(note:NSNotification)
    {
        let userInfo  = note.userInfo
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.view.transform = CGAffineTransformIdentity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
}

extension AutoKey:UIGestureRecognizerDelegate{
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if  NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView"{
            // 去掉跟tableviewcell的冲突
            return false
        }
        return true
    }
    
}
