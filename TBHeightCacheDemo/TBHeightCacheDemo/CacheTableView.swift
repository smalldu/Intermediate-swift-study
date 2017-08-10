//
//  CacheTableView.swift
//  TBHeightCacheDemo
//
//  Created by duzhe on 2017/7/24.
//  Copyright © 2017年 Zoey Shi. All rights reserved.
//

import UIKit

public class CacheTableView: UITableView {
  
  /// 存储 reuse_id 和 临时cell
  private var reuse_ids:[String:UITableViewCell?] = [:]
  
  /// 缓存高度
  private var cacheHeight:[IndexPath:CGFloat] = [:]
  
  /// 是否需要预缓存 默认不需要  因为有可能一个table中有很多section是不需要的
  public var shouldPreCached:Bool = false
  
  
  private lazy var systemAccessoryWidths:[UITableViewCellAccessoryType:CGFloat] = {
    return [
      UITableViewCellAccessoryType.none : 0 ,
      .disclosureIndicator : 34 ,
      .detailDisclosureButton : 68 ,
      .checkmark : 40 ,
      .detailButton : 48
    ]
  }()
  
  
  private lazy var isSystemVersionEqualOrGreaterThan10_2:Bool = {
    print("---current version \(UIDevice.current.systemVersion)")
    return UIDevice.current.systemVersion.compare("10.2") != .orderedAscending
  }()
  
  /// 预缓存  也可以手动调用
  public func preCacheIfNeeded(){
    if !shouldPreCached {
      return
    }
    let runloop = CFRunLoopGetCurrent()
    let runloopMode = CFRunLoopMode.defaultMode
    var indexPathsTobePrecached = self.allIndexPathsToBePrecached()
    let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { (observer, _ ) in
      
      // 预缓存任务都已完成 移除Observer
      if indexPathsTobePrecached.count == 0 {
        CFRunLoopRemoveObserver(runloop, observer, runloopMode)
        return
      }
      
      // 取出第一个任务
      let indexPath = indexPathsTobePrecached[0]
      indexPathsTobePrecached.removeFirst()
      
      // 这个方法将创建一个 Source 0 任务，分发到指定线程的 RunLoop 中，在给定的 Mode 下执行，若指定的 RunLoop 处于休眠状态，则唤醒它处理事件
      self.perform(#selector(CacheTableView.precacheIndexPathIfNeeded(_:)), on: Thread.main , with: indexPath, waitUntilDone: false, modes: [RunLoopMode.defaultRunLoopMode.rawValue])
    }
    CFRunLoopAddObserver(runloop, observer, runloopMode)
  }
  
  func precacheIndexPathIfNeeded(_ indexPath:IndexPath){
    guard let delegate = self.delegate else { return }
    if cacheHeight[indexPath] == nil{
      if let height = delegate.tableView?(self, heightForRowAt: indexPath) {
        cacheHeight[indexPath] = height
        print("预缓存\(indexPath.section) , \(indexPath.row) -- \(height)")
      }
    }
  }
  
  /// 获取所有需要被缓存的indexPath
  ///
  /// - Returns: [IndexPath]
  func allIndexPathsToBePrecached() -> [IndexPath]{
    var allIndexPaths: [IndexPath] = []
    for section in 0..<self.numberOfSections {
      for row in 0..<self.numberOfRows(inSection: section) {
        print("section:\(section), row:\(row)")
        let indexPath = IndexPath(row: row, section: section)
        if cacheHeight[indexPath] == nil {
          allIndexPaths.append(indexPath)
        }
      }
    }
    return allIndexPaths
  }
  
  
  /// 获取高度
  ///
  /// - Parameters:
  ///   - reuse_id: 服用的id
  ///   - indexPath: indexPath
  ///   - callback: 回调 需要填充实体
  /// - Returns: 高度
  public func heighFor( reuse_id: String , indexPath:IndexPath , callback:((_ cell:UITableViewCell)->Void) ) -> CGFloat {
    // 如果已经缓存 直接返回
    if let height = cacheHeight[indexPath] {
      print("from cache")
      return height
    }
    
    if let _ = reuse_ids[reuse_id] {
      // doNothing
      print("have cell")
    }else{
      let cell = self.dequeueReusableCell(withIdentifier: reuse_id)
      reuse_ids[reuse_id] = cell
    }
    guard let cell = reuse_ids[reuse_id] as? UITableViewCell else {
      fatalError("reuseIdentity error")
    }
    // 手动调用已确保和屏幕上显示的保持一致
    cell.prepareForReuse()
    // 赋值
    callback(cell)
    
    
    var contentViewWidth = self.frame.width
    var cellBounds = cell.bounds
    cellBounds.size.width = contentViewWidth
    cell.bounds = cellBounds
    
    var accessoryWidth:CGFloat = 0
    // If a cell has accessory view or system accessory type, its content view's width is smaller
    // than cell's by some fixed values.
    if let view = cell.accessoryView {
      accessoryWidth = view.frame.width
    }else{
      accessoryWidth = systemAccessoryWidths[cell.accessoryType] ?? 0
    }
    contentViewWidth -= accessoryWidth
    
    var fittingHeight:CGFloat = 0
    
    if contentViewWidth>0 {
      //手动添加一个约束 确保动态内容 如label 这个很重要不然需要指定 label 的 preferredMaxLayoutWidth 属性
      let widthFenceConstraint = NSLayoutConstraint(item: cell.contentView,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: self.frame.width)
      
      
      
      var edgeConstraints:[NSLayoutConstraint] = []
      //after iOS 10.3, Auto Layout engine will add an additional 0 width constraint onto cell's content view, to avoid that, we add constraints to content view's left, right, top and bottom.
      if isSystemVersionEqualOrGreaterThan10_2 {
        // To avoid confilicts, make width constraint softer than required (1000)
        widthFenceConstraint.priority = UILayoutPriorityRequired - 1
        
        // Build edge constraints
        let leftConstraint = NSLayoutConstraint(item: cell.contentView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: cell,
                                                attribute: .left,
                                                multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: cell.contentView,
                                                 attribute: .right ,
                                                 relatedBy: .equal,
                                                 toItem: cell,
                                                 attribute: .right,
                                                 multiplier: 1.0, constant: accessoryWidth)
        let topConstraint = NSLayoutConstraint(item: cell.contentView,
                                               attribute: .top ,
                                               relatedBy: .equal,
                                               toItem: cell,
                                               attribute: .top,
                                               multiplier: 1.0, constant: 0)
        let btmConstraint = NSLayoutConstraint(item: cell.contentView,
                                               attribute: .bottom ,
                                               relatedBy: .equal,
                                               toItem: cell,
                                               attribute: .bottom,
                                               multiplier: 1.0, constant: 0)
        
        edgeConstraints = [leftConstraint,rightConstraint,topConstraint,btmConstraint]
        cell.addConstraints(edgeConstraints)
      }
      cell.contentView.addConstraint(widthFenceConstraint)
      let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
      // 移除约束
      cell.contentView.removeConstraint(widthFenceConstraint)
      cacheHeight[indexPath] = size.height + 1
      fittingHeight = size.height + 1
    }
    return fittingHeight
  }
  
  // MARK: - some override
  
  public override func reloadData() {
    self.cacheHeight.removeAll()
    super.reloadData()
    self.preCacheIfNeeded()
  }
  
  public override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
    let tmpCacheHeight = cacheHeight
    for (k,_) in tmpCacheHeight {
      if sections.contains(k.section) {
        cacheHeight[k] = nil
      }
    }
    super.reloadSections(sections, with: animation)
    self.preCacheIfNeeded()
  }
  
  public override func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
    let tmpCacheHeight = cacheHeight
    for (k,_) in tmpCacheHeight {
      if indexPaths.contains(k) {
        cacheHeight[k] = nil
      }
    }
    super.reloadRows(at: indexPaths, with: animation)
    self.preCacheIfNeeded()
  }
  
  public override func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
    self.cacheHeight.removeAll()
    super.insertSections(sections, with: animation)
    self.preCacheIfNeeded()
  }
  
  public override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
    self.cacheHeight.removeAll()
    super.insertRows(at: indexPaths, with: animation)
    self.preCacheIfNeeded()
  }
  
  public override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
    self.cacheHeight.removeAll()
    super.deleteRows(at: indexPaths, with: animation)
    self.preCacheIfNeeded()
  }
  
  public override func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
    self.cacheHeight.removeAll()
    super.deleteSections(sections, with: animation)
    self.preCacheIfNeeded()
  }
  
  public override func moveSection(_ section: Int, toSection newSection: Int) {
    let tmpCacheHeight = cacheHeight
    for (k,_) in tmpCacheHeight {
      if k.section == section {
        let newKey = IndexPath(row: k.row, section: newSection)
        (cacheHeight[k],cacheHeight[newKey]) = (cacheHeight[newKey],cacheHeight[k])
      }
    }
    super.moveSection(section, toSection: newSection)
    self.preCacheIfNeeded()
  }
  
  public override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
    let tmpCacheHeight = cacheHeight
    for (k,_) in tmpCacheHeight {
      if k == indexPath {
        (cacheHeight[k],cacheHeight[newIndexPath]) = (cacheHeight[newIndexPath],cacheHeight[k])
        break
      }
    }
    super.moveRow(at: indexPath, to: newIndexPath)
    self.preCacheIfNeeded()
  }
}


