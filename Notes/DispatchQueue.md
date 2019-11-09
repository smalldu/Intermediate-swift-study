#### GCD - DispatchQueue 

> 以前的GCD是基于C的API ， swift3 以后苹果基于GCD封装了一层，我们可以以更swifty的方式来使用GCD

几个概念：

##### 同步 - sync

- 并发队列中 - concurrent : 没开启新线程 ， 串行执行任务
- 创建的串行队列 : 没开启新线程 ， 串行执行任务
- 主队列:  没开启新线程 ， 串行执行任务

##### 异步 - async

- 并发队列中 - concurrent : 有开启新线程 ， 并发执行任务
- 创建的串行队列 : 有开启新线程 ， 串行执行任务
- 主队列:  没开启新线程 ， 串行执行任务

###基本用法 

系统自带全局队列主队列

可以指定不同的优先级 
```
let backgroudQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
backgroudQueue.sync {
  print("eee")
}

backgroudQueue.sync {
  print("aaa")
}
```


延时执行 

```
let delayInseconds = 1.0
DispatchQueue.main.asyncAfter(deadline: .now() + delayInseconds) { 
  print("1s after")
}
```

基本的异步执行返回更新UI代码

```
DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async{
    // 一些计算 
    DispatchQueue.main.async{
        // 更新UI
    }
}
```

### 进阶用法

取消任务 
```
let block = DispatchWorkItem {
}
DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: block)

block.cancel() // 取消任务
print(block.isCancelled)
```

>使用DispatchQueue 执行的任务对象为`DispatchWorkItem` 我们可以对任何队列进行取消操作 


dispatch barriers 解决读写问题 

```swift
//  创建一个并行队列
fileprivate let concurrentPhotoQueue = DispatchQueue(label: "com.demo.queue", attributes: .concurrent )
fileprivate var _photos: [Photo] = []
var photos: [Photo] {
  var photosCopy: [Photo]!
  // 读取操作 和写入操作在同一个并行队列中
  concurrentPhotoQueue.sync {
    photosCopy = self._photos
  }
  return photosCopy
}

func addPhoto(_ photo: Photo) {
  // 写入操作 加上  barrier 表示在执行期间 其他操作需要等待这个操作执行完才能开始 
  concurrentPhotoQueue.async(flags: .barrier) {
    self._photos.append(photo)
    DispatchQueue.main.async {
    }
  }
}
```

dispatch group 的使用 ， 这个是非常使用 也很常见 

```
DispatchQueue.global(qos: .userInitiated) .async {
  // 使用 wait block住当前线程 所以 这里需要使用一个后台线程以免阻塞主线程
  let downloadGroup = DispatchGroup() // 创建一个 dispatch group
  for i in 0...10 {
    let url = URL(string: someUrl)
    downloadGroup.enter()  // 通知 group 有个任务开始 enter和leave必须成对出现  否则 app将会crash
    
    // A download task
    let photo = DownloadTask(url: url!) { result in
      // 通知group 任务完成
      downloadGroup.leave()
    }
  }
  downloadGroup.wait() // wait 阻塞当前线程 等待其他任务完成  这里也可指定等待超时时间
  //      downloadGroup.wait(timeout: DispatchTime.now()+25) // 25s 后超时
  DispatchQueue.main.async {
    completion()
  }
}
```

上面这段伪代码解释了 dispatch group的基本用法 ， 就是 需要在后台线程执行 N 个并行的任务，当所有任务完成后，做某件事情  

还有一种更方便的写法，如下：

```
let downloadGroup = DispatchGroup()
for i in 0...10 {
  let url = URL(string: someUrl)

  downloadGroup.enter()
  let photo = DownloadTask(url: url!) { result in
    downloadGroup.leave()
  }
}
downloadGroup.notify(queue: DispatchQueue.main){
  // 所有任务执行完 汇总
  completion()
}
```


以上 😊！





