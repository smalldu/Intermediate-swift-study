//
//  TableDemoViewController.swift
//  NavPopAction
//
//  Created by duzhe on 2017/6/26.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class TableDemoViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "列表页"
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return 15
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("real \(indexPath)")
    
  }
}


