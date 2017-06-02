//
//  PresentViewController.swift
//  PresentKit
//
//  Created by duzhe on 2017/6/1.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {
  
  fileprivate var label:UILabel!
  fileprivate let text: String
  
  init(_ text:String) {
    self.text = text
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    
    label = UILabel()
    self.view.addSubview(label)
    label.text = text
    label.textAlignment = .center
    label.textColor = UIColor.white
    label.frame = self.view.bounds
  }
  
}
