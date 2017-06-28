//
//  POPViewController.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/23.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class POPViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "明细页"
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func popback(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
}
