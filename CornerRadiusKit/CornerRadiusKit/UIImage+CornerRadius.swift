//
//  UIImage+CornerRadius.swift
//  CornerRadiusKit
//
//  Created by duzhe on 2017/6/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

extension UIImage {
  
  /// 指定长宽
  ///
  /// - Parameter toSize: 指定size
  /// - Returns: UIImage
  func reSizeImage(_ toSize:CGSize)->UIImage?{
    UIGraphicsBeginImageContext(toSize)
    self.draw(in: CGRect(origin: .zero , size: toSize))
    let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return reSizeImage
  }
  
  
  /// 异步绘制圆角图片
  ///
  /// - Parameters:
  ///   - radius: radius
  ///   - complete: 完成回调
  func roundImageByCornerRadius(_ radius:CGFloat , resizeToSqure:Bool = true , inSize:CGSize = .zero , borderWidth:CGFloat = 0,borderColor:UIColor = UIColor.black ) -> UIImage?{
    var size = self.size
    var img = self
    if resizeToSqure && size.width != size.height{
      // 如果需要把图形改成正方形
      var needResize = false
      if size.width > size.height {
        needResize = true
        size.width = size.height
      }else if size.height>size.width {
        needResize = true
        size.height = size.width
      }
      if needResize {
        if let image = self.reSizeImage(size){
          img = image
        }
      }
    }
    
    var radius = radius
    var borderWidth = borderWidth
    if inSize != .zero { // 指定imageview的size
      // 调整真实的 radius 角度
      let rate = ( size.width/inSize.width )
      radius = radius*rate
      borderWidth = borderWidth*rate
    }
    
    UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
    let context = UIGraphicsGetCurrentContext()
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    context?.scaleBy(x: 1, y: -1)
    context?.translateBy(x: 0, y: -rect.size.height)
    
    let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth) , byRoundingCorners: .allCorners , cornerRadii: CGSize(width: radius, height: borderWidth))
    path.close()
    context?.saveGState()
    path.addClip()
    context?.draw(img.cgImage!, in: rect)
    context?.restoreGState()
    
    if borderWidth > 0 {
      let strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale
      let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
      let strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0
      let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: .allCorners, cornerRadii:CGSize(width: strokeRadius, height: borderWidth))
      path.close()
      path.lineWidth = borderWidth
      borderColor.setStroke()
      path.stroke()
    }
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  
  /// 圆形图片
  ///
  /// - Parameter complete: 回调
  func circleImage() -> UIImage?{
    return roundImageByCornerRadius(1000)
  }
  
  
  
}
