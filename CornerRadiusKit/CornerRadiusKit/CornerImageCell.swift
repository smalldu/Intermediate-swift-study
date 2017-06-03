//
//  CornerImageCell.swift
//  CornerRadiusKit
//
//  Created by duzhe on 2017/6/3.
//  Copyright © 2017年 duzhe. All rights reserved.
//

import UIKit

class CornerImageCell: UITableViewCell {
  
  @IBOutlet weak var cornerImageView:UIImageView!
  @IBOutlet weak var descLabel:UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func configWith(_ index:Int) {
    switch index {
    case 0:
      cornerImageView.image = UIImage(named: "h_biger")?.imageByRoundCornerRadius(1000)
      descLabel.text = "高度大于宽度"
    case 1:
      cornerImageView.image = UIImage(named: "w_big")?.imageByRoundCornerRadius(1000)
      descLabel.text = "宽度小于高度"
    case 2:
      cornerImageView.image = UIImage(named: "w_h_equal")?.imageByRoundCornerRadius(1000)
      descLabel.text = "宽度等于高度"
    default:
      break
    }
  }
  
  func configNewWith(_ index:Int) {
    switch index {
    case 0:
      cornerImageView.image = UIImage(named: "h_biger")?.circleImage()
      descLabel.text = "高度大于宽度"
    case 1:
      cornerImageView.image = UIImage(named: "w_big")?.roundImageByCornerRadius(1000, inSize: CGSize(width: 60, height: 60), borderWidth: 2, borderColor: UIColor.darkGray)
      descLabel.text = "宽度小于高度"
    case 2:
      cornerImageView.image = UIImage(named: "w_h_equal")?.roundImageByCornerRadius(10, inSize: CGSize(width: 60, height: 60), borderWidth: 1, borderColor: UIColor.red)
      descLabel.text = "宽度等于高度  也可以指定圆角度数"
    default:
      break
    }
  }
  
  
}
