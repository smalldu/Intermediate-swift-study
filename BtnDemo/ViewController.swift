//
//  ViewController.swift
//  BtnDemo
//
//  Created by duzhe on 2017/7/14.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var btn1: UIButton!
  @IBOutlet weak var btn2: UIButton!
  @IBOutlet weak var btn3: UIButton!
  @IBOutlet weak var btn4: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    btn1.layoutWith(style: .top , space: 10)
    btn2.layoutWith(style: .left , space: 10)
    btn3.layoutWith(style: .bottom , space: 10)
    btn4.layoutWith(style: .right , space: 10)
    
    btn1.border()
    btn2.border()
    btn3.border()
    btn4.border()
  }
}


extension UIButton {
  func border(){
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.5
  }
}


enum ButtonEdgeStyle {
  case top  // image 上 label 下 
  case left // image 左 label 右
  case bottom // image 下 label 上 
  case right // image 右 label 左
}

extension UIButton {
  
  /// button 内布局样式
  ///
  /// - Parameters:
  ///   - style: 样式
  ///   - space: 间隔
  func layoutWith( style:ButtonEdgeStyle , space:CGFloat ) {
    guard let image = self.imageView?.image , let _ = self.titleLabel else {
      return
    }
    let imageSize = image.size
    let labelWidth: CGFloat = self.titleLabel?.intrinsicContentSize.width ?? 0
    let labelHeight: CGFloat = self.titleLabel?.intrinsicContentSize.height ?? 0
    
    var imageEdgeInsets = UIEdgeInsets.zero
    var labelEdgeInsets = UIEdgeInsets.zero
    
    switch style {
    case .top:
      imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space/2, left: 0, bottom: 0, right: -labelWidth)
      labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -imageSize.height-space/2, right: 0)
    case .left:
      imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2, bottom: 0, right: space/2)
      labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2, bottom:0, right: -space/2)
    case .bottom:
      imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0 , right: -labelWidth)
      labelEdgeInsets = UIEdgeInsets(top: -imageSize.height-space/2, left: -imageSize.width, bottom: 0, right: 0)
    case .right:
      imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2, bottom: 0, right: -labelWidth-space/2)
      labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width-space/2, bottom:0, right: imageSize.width+space/2)
    }
    self.titleEdgeInsets = labelEdgeInsets
    self.imageEdgeInsets = imageEdgeInsets
  }
  
}
