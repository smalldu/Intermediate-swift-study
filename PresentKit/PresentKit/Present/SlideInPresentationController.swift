//
//  SlideInPresentationController.swift
//  MedalCount
//
//  Created by duzhe on 2017/6/1.
//  Copyright © 2017年 Ron Kliffer. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {

  // MARK: - Properties
  private var direction: PresentionDirection
  fileprivate var dimmingView: UIView!
  
  
  init(presentedViewController: UIViewController,
                presenting presentingViewController: UIViewController? ,
                direction: PresentionDirection ) {
    self.direction = direction
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    setupDimmingView()
  }
  
  func setupDimmingView(){
    dimmingView = UIView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    dimmingView.alpha = 0.0
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    dimmingView.addGestureRecognizer(recognizer)
  }
  
  dynamic func handleTap(recognizer: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true)
  }
  
  override func presentationTransitionWillBegin() {
    // 管理试图层级 展现的 和 被展现的vc
    containerView?.insertSubview(dimmingView, at: 0)
    
    NSLayoutConstraint.activate(
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                     options: [], metrics: nil, views: ["dimmingView": dimmingView]))
    NSLayoutConstraint.activate(
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                     options: [], metrics: nil, views: ["dimmingView": dimmingView]))
    
    // 做动画
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 1.0
      return
    }
    coordinator.animate(alongsideTransition: { (context) in
      self.dimmingView.alpha = 1
    })
  }
  
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.0
    })
  }
  
  override func containerViewWillLayoutSubviews() {
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
  
  override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    switch direction {
    case .left,.right:
      return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
    case .bottom,.top:
      return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
    }
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    var frame = CGRect.zero
    frame.size = size(forChildContentContainer: presentedViewController
      , withParentContainerSize: containerView!.bounds.size )
    
    switch direction {
    case .right:
      frame.origin.x = containerView!.frame.width/3
    case .bottom:
      frame.origin.y = containerView!.frame.height/3
    default:
      frame.origin = CGPoint.zero
    }
    
    return frame
  }

  
}
