//
//  TipViewController.swift
//  iconfont-study
//
//  Created by duzhe on 2017/8/10.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
  
  @IBOutlet weak var tipView: UIView!
  @IBOutlet weak var doneBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tipView.layer.cornerRadius = 10
    tipView.layer.masksToBounds = true
    doneBtn.addTarget(self, action: #selector(done), for: .touchUpInside)
  }
  
  
  func done(){
    self.dismiss(animated: true, completion: nil)
  }
  
}
