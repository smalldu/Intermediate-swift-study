//
//  CCell.swift
//  TBHeightCacheDemo
//
//  Created by Zoey Shi on 2017/7/23.
//  Copyright © 2017年 Zoey Shi. All rights reserved.
//

import UIKit

class CCell: UITableViewCell {
  
  
  @IBOutlet weak var lb:UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    lb.backgroundColor = UIColor.red
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    print("\(self.contentView.frame.height)-------")
  }
  
}
