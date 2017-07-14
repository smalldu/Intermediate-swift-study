# Intermediate-swift-study  

>学习swift过程中总结的一些技巧（demo项目）汇总 


### PresentKit 

此demo主要包含 自定义`UIPresentViewController` 自定义present动画 

![运行效果](https://github.com/smalldu/Intermediate-swift-study/blob/master/Resources/PresentKit.gif)


### CornerRadiusKit

demo展示了圆角图片的解决方案，都知道圆角用`view.layer.cornerRadius + ClipToBounds` or `masksToBounds` 会导致离屏渲染。
导致GPU消耗太大 

很多解决方案是CPU预先绘制bitmap，然后交给GPU直接渲染 

代码网上一大堆，但是都有一个共同的问题，比如要显示的圆形图片长宽不一致会导致圆形变形，很丑 -- 
这里就这个问题提供解决方案，并且可以指定角度，添加边框 

![运行效果](https://github.com/smalldu/Intermediate-swift-study/blob/master/Resources/corner.gif)


虽然可以完美解决这个问题，但是因为GPU消耗过多把任务交给CPU，如果需要处理的量太大会导致CPU消耗太大 ， 这时候建议将绘制bitmap的代码写到后台线程中。。

写在后台线程会导致延迟显示，尤其是复用cell的tableview 。 滑动的时候不卡顿了，但图片显示稍微推迟了

这个需要根据项目权衡 -- 

### DispatchQueue 

`DispatchQueue` 日常用法 👉 ： [DispatchQueue](https://github.com/smalldu/Intermediate-swift-study/blob/master/Notes/DispatchQueue.md)  (在Notes文件夹)

### UIButton 图片居左、居右、居下、居上

利用`UIButton`的两个属性 `titleEdgeInsets` 和 `imageEdgeInsets` 写一个分类即可 

代码很简单 ： 
```
enum ButtonEdgeStyle {
  case top  // image 上 label 下
  case left // image 左 label 右
  case bottom // image 下 label 上
  case right // image 右 label 左
}

extension UIButton {
  
  /// button 内布局样式
  ///
  /// - Parameters:
  ///   - style: 样式
  ///   - space: 间隔
  func layoutWith( style:ButtonEdgeStyle , space:CGFloat ) {
    guard let image = self.imageView?.image , let _ = self.titleLabel else {
      return
    }
    let imageSize = image.size
    let labelWidth: CGFloat = self.titleLabel?.intrinsicContentSize.width ?? 0
    let labelHeight: CGFloat = self.titleLabel?.intrinsicContentSize.height ?? 0
    
    var imageEdgeInsets = UIEdgeInsets.zero
    var labelEdgeInsets = UIEdgeInsets.zero
    
    switch style {
    case .top:
      imageEdgeInsets = UIEdgeInsets(top: -labelHeight-space/2, left: 0, bottom: 0, right: -labelWidth)
      labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -imageSize.height-space/2, right: 0)
    case .left:
      imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2, bottom: 0, right: space/2)
      labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2, bottom:0, right: -space/2)
    case .bottom:
      imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0 , right: -labelWidth)
      labelEdgeInsets = UIEdgeInsets(top: -imageSize.height-space/2, left: -imageSize.width, bottom: 0, right: 0)
    case .right:
      imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2, bottom: 0, right: -labelWidth-space/2)
      labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width-space/2, bottom:0, right: imageSize.width+space/2)
    }
    self.titleEdgeInsets = labelEdgeInsets
    self.imageEdgeInsets = imageEdgeInsets
  }
}
```

使用起来更简单 
```
btn1.layoutWith(style: .top , space: 10)
btn2.layoutWith(style: .left , space: 10)
btn3.layoutWith(style: .bottom , space: 10)
btn4.layoutWith(style: .right , space: 10)
```


效果 ：
![效果](https://github.com/smalldu/Intermediate-swift-study/blob/master/Resources/btmDemo.jpeg)


*** 









