//
//  UIImage+Old.swift
//  CornerRadiusKit
//
//  Created by duzhe on 2017/6/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


extension UIImage {
  func imageAddcornerWithRadius(_ radius:CGFloat , size:CGSize , complete:@escaping ((UIImage?) -> Void) )  {
    DispatchQueue.global(qos:  .userInitiated ).async {
      var rect = CGRect(origin: .zero , size: size)
      if size.width > size.height {
        rect.origin.x = (size.width-size.height)/2
        rect.size.width = rect.height
      }else if size.height>size.width {
        rect.origin.y = ( size.height-size.width )/2
        rect.size.height = rect.width
      }
      
      UIGraphicsBeginImageContextWithOptions(rect.size, false , UIScreen.main.scale)
      let ctx = UIGraphicsGetCurrentContext()
      let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
      ctx?.addPath(path.cgPath)
      ctx?.clip()
      self.draw(in: rect)
      ctx?.drawPath(using:  .fillStroke)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      DispatchQueue.main.async {
        complete(newImage)
      }
    }
  }
  
  func imageByRoundCornerRadius(_ radius:CGFloat,corners:UIRectCorner,borderWidth:CGFloat,borderColor:UIColor?,borderLineJoin:CGLineJoin)->UIImage{
    
    UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
    
    let context = UIGraphicsGetCurrentContext()
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    context?.scaleBy(x: 1, y: -1)
    context?.translateBy(x: 0, y: -rect.size.height)
    
    let minSize = min(size.width, size.height)
    if borderWidth < minSize / 2 {
      let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
      path.close()
      context?.saveGState()
      path.addClip()
      context?.draw(self.cgImage!, in: rect)
      context?.restoreGState()
    }
    
    if borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0 {
      let strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale
      let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
      let strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0
      let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii:CGSize(width: strokeRadius, height: borderWidth))
      path.close()
      
      path.lineWidth = borderWidth
      path.lineJoinStyle = borderLineJoin
      borderColor?.setStroke()
      path.stroke()
    }
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
  func imageByRoundCornerRadius(_ radius:CGFloat,borderWidth:CGFloat,borderColor:UIColor?)->UIImage{
    return self.imageByRoundCornerRadius(radius, corners: UIRectCorner.allCorners, borderWidth: borderWidth, borderColor: borderColor, borderLineJoin: CGLineJoin.miter)
  }
  
  func imageByRoundCornerRadius(_ radius:CGFloat)->UIImage{
    return self.imageByRoundCornerRadius(radius, borderWidth: 0, borderColor: nil)
  }
}
