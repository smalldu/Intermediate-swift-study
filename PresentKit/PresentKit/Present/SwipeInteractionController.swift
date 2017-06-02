//
//  SwipeInteractionController.swift
//  PresentKit
//
//  Created by duzhe on 2017/6/1.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit


// TODO:- 手势相关
class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

  // MARK -: properties
  
  var interactionInProgress = false
  private var shouldCompleteTransition = false
  private weak var presentViewController: UIViewController!
  private weak var btmViewController: UIViewController!
  var isPresent = true {
    didSet{
      if isPresent {
        if btmViewController != nil {
          self.prepareGestureRecognizerInView(view: btmViewController.view)
        }
      }else{
        if presentViewController != nil {
          self.prepareGestureRecognizerInView(view: presentViewController.view)
        }
      }
    }
  }
  
  func wireToViewController(presentViewController:UIViewController , btmViewController:UIViewController){
    self.presentViewController = presentViewController
    self.btmViewController = btmViewController
    if isPresent {
      self.prepareGestureRecognizerInView(view: btmViewController.view)
    }else{
      self.prepareGestureRecognizerInView(view: presentViewController.view)
    }
  }
  
  private func prepareGestureRecognizerInView(view: UIView) {
//    UIScreenEdgePanGestureRecognizer
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
//    gesture.edges = UIRectEdge.left
    view.addGestureRecognizer(gesture)
  }
  
  func handleGesture(_ gesture: UIPanGestureRecognizer) {
    guard let view = gesture.view?.superview else {
      return
    }
    // 移动的距离
    let translation = gesture.translation(in: view)
    
    var progress = fabs(translation.x / 200)
    progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
    switch gesture.state {
    case .began:
      interactionInProgress = true
      if let presentViewController = presentViewController{
        btmViewController?.present(presentViewController, animated: true, completion: nil)
      }else{
        presentViewController?.dismiss(animated: true, completion: nil)
      }
    case .changed:
      // 是否可以完成
      shouldCompleteTransition = progress > 0.5
      update(progress)
      
    case .cancelled:
      interactionInProgress = false
      cancel()
    case .ended:
      interactionInProgress = false
      if !shouldCompleteTransition {
        cancel()
      } else {
        finish()
      }
    default:
      print("Unsupported")
    }
  }
}
