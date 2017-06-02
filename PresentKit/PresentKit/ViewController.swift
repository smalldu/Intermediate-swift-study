//
//  ViewController.swift
//  PresentKit
//
//  Created by duzhe on 2017/6/1.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var isMoveSwitch:UISwitch!
  lazy var slideInTransitionDelegate = SlideInPresentationManager()
  override func viewDidLoad() {
    super.viewDidLoad()
    slideInTransitionDelegate.isMoveTogher = isMoveSwitch.isOn
    
  }
  
  @IBAction func goLeft(_ sender: Any) {
    let vc1 = PresentViewController("LEFT")
    slideInTransitionDelegate.direction = .left
    slideInTransitionDelegate.isMoveTogher = isMoveSwitch.isOn
    vc1.view.backgroundColor = UIColor.red
    vc1.transitioningDelegate = slideInTransitionDelegate
    vc1.modalPresentationStyle = .custom
    self.present(vc1, animated: true, completion: nil)
  }
  
  @IBAction func goRight(_ sender: Any) {
    slideInTransitionDelegate.direction = .right
    slideInTransitionDelegate.isMoveTogher = isMoveSwitch.isOn
    
    let vc = PresentViewController("RIGHT")
    vc.view.backgroundColor = UIColor.blue
    vc.transitioningDelegate = slideInTransitionDelegate
    vc.modalPresentationStyle = .custom
    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func goTop(_ sender: Any) {
    slideInTransitionDelegate.direction = .top
    slideInTransitionDelegate.isMoveTogher = isMoveSwitch.isOn
    
    let vc = PresentViewController("TOP")
    vc.view.backgroundColor = UIColor.green
    vc.transitioningDelegate = slideInTransitionDelegate
    vc.modalPresentationStyle = .custom
    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func goBtm(_ sender: Any) {
    slideInTransitionDelegate.direction = .bottom
    slideInTransitionDelegate.isMoveTogher = isMoveSwitch.isOn
    
    let vc = PresentViewController("BOTTOM")
    vc.view.backgroundColor = UIColor.purple
    vc.transitioningDelegate = slideInTransitionDelegate
    vc.modalPresentationStyle = .custom
    self.present(vc, animated: true, completion: nil)
  }
}

