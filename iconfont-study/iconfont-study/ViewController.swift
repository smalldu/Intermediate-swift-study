//
//  ViewController.swift
//  iconfont-study
//
//  Created by duzhe on 2017/8/10.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var imageV: UIImageView!
  @IBOutlet weak var effectView: UIVisualEffectView!
  @IBOutlet var tipView: UIView!
  
  var effect: UIVisualEffect?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    label.text = Iconfont.狐狸.rawValue
    label.font = UIFont.iconfont(ofSize: 50)
    label.textColor = UIColor.brown
    
    imageV.image = UIImage(text: Iconfont.刺猬 , fontSize: 20)
    tipView.layer.cornerRadius = 10
    effect = effectView.effect
    effectView.effect = nil
    effectView.isHidden = true
  }
  
  @IBAction func showIn(_ sender: Any) {
    tipView.center = view.center
    tipView.frame.size = CGSize(width: 270, height: 130)
    view.addSubview(tipView)
    tipView.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
    effectView.isHidden = false
    
    UIView.animate(withDuration: 0.3, animations: { 
      self.effectView.effect = self.effect
      self.tipView.alpha = 1
      self.tipView.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  
  @IBAction func fadeOut(_ sender: Any) {
    UIView.animate(withDuration: 0.3, animations: { 
      self.tipView.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
      self.tipView.alpha = 0
      self.effectView.effect = nil
    }) { _ in
      self.tipView.transform = CGAffineTransform.identity
      self.effectView.isHidden = true
      self.tipView.removeFromSuperview()
    }
  }
  
  @IBAction func showIn3(_ sender: Any) {
    
    Alert.shared.show { 
      print("dismiss ~ ")
    }
  }
}


class Alert {
  static let shared:Alert = Alert()
  private init() {
    
  }
  
  private let _sw = UIScreen.main.bounds.width
  private let _sh = UIScreen.main.bounds.height
  
  private let alertWidth: CGFloat = 270
  fileprivate var alertBackView: UIView! // 浅黑色背景
  fileprivate var alertBgView: UIView! // 弹出框背景
  fileprivate var titleLabel: UILabel!
  fileprivate var contentLabel: UILabel!
  fileprivate var btmBtn: UIButton!
  fileprivate var action:(()->())?
  
  
  func show(action:(()->())?){
    self.alertBackView?.removeFromSuperview()
    self.alertBackView = nil
    self.action = action
    
    alertBackView = UIView()
    alertBackView.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
    alertBackView.frame = CGRect(x: 0, y: 0 , width: _sw, height: _sh)
    UIApplication.shared.keyWindow?.addSubview(alertBackView)
    
    alertBgView = UIView()
    alertBgView.backgroundColor = UIColor.white
    alertBgView.layer.cornerRadius = 10
    alertBgView.layer.masksToBounds = true
    alertBackView.addSubview(alertBgView)
    alertBgView.frame.size = CGSize(width: alertWidth , height: 130)
    alertBgView.frame.origin = CGPoint(x: (_sw-alertWidth)/2, y: (_sh-130)/2)
    
    titleLabel = UILabel()
    alertBgView.addSubview(titleLabel)
    titleLabel.frame = CGRect(x: 0, y: 0 , width: alertWidth , height: 30)
    titleLabel.textAlignment = .center
    titleLabel.text = "This is a title"
    
    contentLabel = UILabel()
    alertBgView.addSubview(contentLabel)
    contentLabel.frame = CGRect(x: 0, y: 30, width: alertWidth, height: 50)
    contentLabel.textAlignment = .center
    contentLabel.text = "This is a content ~ , just a demo . "
    contentLabel.textColor = UIColor.darkGray
    contentLabel.font = UIFont.systemFont(ofSize: 15)
    
    btmBtn = UIButton()
    alertBgView.addSubview(btmBtn)
    btmBtn.frame = CGRect(x: 50, y: 130 - 45 - 8 , width: alertWidth - 100 , height: 40)
    btmBtn.backgroundColor = UIColor.magenta
    btmBtn.setTitle("Done", for: .normal)
    btmBtn.addTarget(self, action: #selector(complete), for: .touchUpInside)
    
    alertBgView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    alertBackView.alpha = 1
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveEaseInOut , animations: {
      self.alertBgView.alpha = 1
      self.alertBgView.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  
  @objc func complete(){
    dismiss()
    self.action?()
  }
  
  func dismiss(){
    UIView.animate(withDuration: 0.3, animations: {
      self.alertBgView.alpha = 0
      self.alertBackView.alpha = 0
      self.alertBgView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    }) { b in
      self.alertBackView?.removeFromSuperview()
      self.alertBackView = nil
    }
  }
}

public extension UIFont {
  public class func iconfont(ofSize: CGFloat) -> UIFont? {
    return UIFont(name: "iconfont", size: ofSize)
  }
}

public extension UIImage {
  public convenience init?(text: Iconfont, fontSize: CGFloat, imageSize: CGSize = CGSize.zero, imageColor: UIColor = UIColor.black) {
    guard let iconfont = UIFont.iconfont(ofSize: fontSize) else {
      self.init()
      return nil
    }
    var imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
    if __CGSizeEqualToSize(imageSize, CGSize.zero) {
      imageRect = CGRect(origin: CGPoint.zero, size: text.rawValue.size(attributes: [NSFontAttributeName: iconfont]))
    }
    UIGraphicsBeginImageContextWithOptions(imageRect.size, false, UIScreen.main.scale)
    defer {
      UIGraphicsEndImageContext()
    }
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.center
    text.rawValue.draw(in: imageRect, withAttributes: [NSFontAttributeName : iconfont, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: imageColor])
    guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
      self.init()
      return nil
    }
    self.init(cgImage: cgImage)
  }
}

public enum Iconfont: String {
  case 狐狸 = "\u{e6a6}"
  case 刺猬 = "\u{e6a7}"
}










