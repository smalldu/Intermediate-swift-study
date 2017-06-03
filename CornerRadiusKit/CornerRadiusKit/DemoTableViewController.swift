//
//  DemoTableViewController.swift
//  CornerRadiusKit
//
//  Created by duzhe on 2017/6/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class DemoTableViewController: UITableViewController {
  
  var isNew = false {
    didSet{
      title = isNew ? "New Method":"Old Method"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
  }
  
  @IBAction func changeMethod(_ sender: Any) {
    isNew = !isNew
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "oldCell", for: indexPath) as! CornerImageCell
    if isNew {
      cell.configNewWith(indexPath.row)
    }else{
      cell.configWith(indexPath.row)
    }
    return cell

  }
}
