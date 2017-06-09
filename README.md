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






