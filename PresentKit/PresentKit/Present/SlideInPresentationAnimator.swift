//
//  SlideInPresentationAnimator.swift
//  MedalCount
//
//  Created by duzhe on 2017/6/1.
//  Copyright © 2017年 Ron Kliffer. All rights reserved.
//

import UIKit

class SlideInPresentationAnimator: NSObject {
  fileprivate var direction: PresentionDirection
  let isPresentation: Bool
  let isMoveTogher: Bool
  init(direction: PresentionDirection, isPresentation: Bool,isMoveTogher:Bool) {
    self.isMoveTogher = isMoveTogher
    self.direction = direction
    self.isPresentation = isPresentation
    super.init()
  }
  
}


// MARK: - UIViewControllerAnimatedTransitioning 

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  /// 动画部分
  ///
  /// - Parameter transitionContext:transitionContext
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
    guard let controller = transitionContext.viewController(forKey: key) else{ return }
    
    let anotherKey: UITransitionContextViewControllerKey = isPresentation ? .from : .to
    guard let anotherController = transitionContext.viewController(forKey: anotherKey) else{ return }
    
    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }
    // final frame
    let presentedFrame = transitionContext.finalFrame(for: controller)
    
    var dissmissFrame = presentedFrame
    switch direction {
    case .left:
      dissmissFrame.origin.x = -presentedFrame.width
    case .right:
      dissmissFrame.origin.x = presentedFrame.maxX
    case .top:
      dissmissFrame.origin.y = -presentedFrame.height
    case .bottom:
      dissmissFrame.origin.y = presentedFrame.maxY
    }
    
    let initialFrame = isPresentation ? dissmissFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dissmissFrame
    
    
    var transformX: CGFloat = 0
    var transformY: CGFloat = 0
    switch direction {
    case .left:
      transformX = presentedFrame.width
    case .right:
      transformX = -presentedFrame.width
    case .top:
      transformY = presentedFrame.height
    case .bottom:
      transformY = -presentedFrame.height
    }
    
    let initialTransform = isPresentation ? CGAffineTransform.identity : CGAffineTransform.identity.translatedBy(x: transformX, y: transformY)
    let finalTransform = isPresentation ? CGAffineTransform.identity.translatedBy(x: transformX, y: transformY) : CGAffineTransform.identity
    
    
    let duration = transitionDuration(using: transitionContext)
    controller.view.frame = initialFrame
    // 是否一起移动
    if self.isMoveTogher {
      anotherController.view.transform = initialTransform
    }
    UIView.animate(withDuration: duration, animations: { 
      controller.view.frame = finalFrame
      if self.isMoveTogher {
        anotherController.view.transform = finalTransform
      }
    }) { finished in
      transitionContext.completeTransition(finished)
    }
  }
  
}
