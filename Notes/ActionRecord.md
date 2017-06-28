# 行为统计规则 


已实现hook系统方法 ： 

- `UIViewController` 的 `viewWillAppear(_:)`  `viewWillDisappear(_:)` (可扩展其他生命周期的方法)
- `UIViewController` 的 `present(_:animated:completion:)` 视图跳转 
- `UINavigationViewController` 的 `pushViewController(_:animated:)` 和 `popViewController(animated:)` 导航视图的跳转 ， 
如需记录详细还需hook住其他相关跳转方法 
- `UIButton` 的各种事件 （ 可选择性的记录某些事件 ）
- 对 `UIView` 的 gesture 手势操作进行hook，目前只添加了 `UITapGestureRecognizer` 点击手势 ， 可扩展 
- 对 `UITableView` 点击事件，目前只支持 `UIViewController` 下的 tableView 点击事件 



### 记录字段  

> 时间精确到毫秒，因为用户的操作可能回比较快，秒级别无法确定先后顺序 

#### 字段 

- 当前用户 uid
- 版本号 version 
- 平台 platform       ios andriod
- 设备编号 device_id
- 当前页面  cur_page
- 当前页标题 cur_page_title
- 前一个页面 pre_page   可以为空
- 前一个页面标题 pre_page_title
- 下一个页面 next_page   可以为空
- 下一个页面标题 next_page_title
- 操作  operation      进入页面、离开页面、跳转 、按钮 、 tableview cell 、 collectionview cell 、 tap  (可添加) 
- 操作视图标识 operation_identity
- 操作视图名称 operation_value 
- 时间 create_time 
- 时间戳 time_stamp 
- 备注 remark 
- ext1 
- ext2 

### 数据同步 

本地数据库采用sqlite 3

客户端做本地存储，用户每次激活应用。查询本地是否存储统计数据。   若有数据，则将数据同步至后台。（一次转成对象数组的json，或约定其他格式）
，客户端清除本地数据重新，继续记录新的行为统计。待下次激活



