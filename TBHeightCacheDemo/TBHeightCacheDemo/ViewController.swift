//
//  ViewController.swift
//  TBHeightCacheDemo
//
//  Created by Zoey Shi on 2017/7/23.
//  Copyright © 2017年 Zoey Shi. All rights reserved.
//

import UIKit
class ReuseEntity: ExpressibleByStringLiteral{
  
  var cell:UITableViewCell?
  var id : String
  init(id: String) {
    self.id = id
  }
  
  required init(stringLiteral value: String) {
    self.id = value
  }
  required convenience init(unicodeScalarLiteral value: String) {
    self.init(stringLiteral: value)
  }
  required convenience init(extendedGraphemeClusterLiteral value: String) {
    self.init(stringLiteral: value)
  }
}
class CacheTableView: UITableView {
  
  var reuse_entitys:[ReuseEntity] = []
  
  private func register(){
    for item in reuse_entitys {
      if item.cell == nil {
        item.cell = self.dequeueReusableCell(withIdentifier: item.id)
      }
    }
  }
  
//  func heighFor( reuse_id: String , indexPath:IndexPath , callEntity: )
  
  
  
  
}









class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

  
  
  @IBOutlet weak var tbaleView: UITableView!
  
  private var tmpCell:CCell?
  private var cacheDictionary:[IndexPath:CGFloat] = [:]
  
  
  
  lazy var items: [String] = {
    return [
      "的宽度细胞的内容查看没有任何具有默认的限制（其宽度由设置只有当它被添加到表视图SDK），所以当你调用 systemLayoutSizeFittingSize：就可以了，约束解算器假定它是有效的COM preSS的宽度很多需要努力找到一个有效的解决方案，当它在错误的高度当然的结果。","任何具有默认的限制（其宽度由设置只",
      "其中 intrinsicSizeForAutolayout 是我为宗旨定义的属性。我想这可能工作同样的方式，设置 preferredMaxLayoutWidth 为的UILabel 取值解决了类似的问题。但是，没有。这是行不通的。这似乎我很少有替代使用丑陋的屏幕宽度检查code有条件地设置取决于屏幕宽度固定高度的限制，这是我真的想避免，因为它那种违背了使用汽车的目的布局摆在首位。"
    ]
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tbaleView.rowHeight = UITableViewAutomaticDimension
    tbaleView.estimatedRowHeight = 100
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CCell
    cell.lb.text = items[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    print(indexPath.row)
    if tmpCell == nil {
      tmpCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CCell
    }
    tmpCell?.prepareForReuse()
    tmpCell?.lb.text = items[indexPath.row]
    //手动添加一个约束 确保动态内容 如label
    let tempWidthConstraint = NSLayoutConstraint(item: tmpCell!.contentView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: tableView.frame.width)
    tmpCell!.contentView.addConstraint(tempWidthConstraint)
    tmpCell?.lb.text = "\(items[indexPath.row])"
    let size = tmpCell?.contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
//    print(size?.height)
    // 移除约束
    tmpCell!.contentView.removeConstraint(tempWidthConstraint)
    
    
    return (size?.height ?? 0)+1
    
//    return UITableViewAutomaticDimension
    
  }
  

  
  
}

