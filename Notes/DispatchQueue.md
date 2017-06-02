

let backgroudQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)

backgroudQueue.sync {
  print("eee")
}

backgroudQueue.sync {
  print("aaa")
}

// 延时执行 
let delayInseconds = 1.0
DispatchQueue.main.asyncAfter(deadline: .now() + delayInseconds) { 
  print("1s after")
}

backgroudQueue.asyncAfter(deadline: .now()) { 
  print("now")
}

// dispatch barriers 解决读写问题 

//: below is a Demo

//fileprivate let concurrentPhotoQueue = DispatchQueue(label: "com.raywenderlich.GooglyPuff.photoQueue", attributes: .concurrent )
//fileprivate var _photos: [Photo] = []
//var photos: [Photo] {
//  var photosCopy: [Photo]!
//  concurrentPhotoQueue.sync {
//    photosCopy = self._photos
//  }
//  return photosCopy
//}
//
//func addPhoto(_ photo: Photo) {
//  concurrentPhotoQueue.async(flags: .barrier) {
//    self._photos.append(photo)
//    DispatchQueue.main.async {
//      
//    }
//  }
//}

//- - --- -  ----------- - - - - - -
// - - - -    barriers  --- - - - - -

// a dispatch group demo , very useful 

//func downloadPhotosWithCompletion(_ completion: BatchPhotoDownloadingCompletionClosure?) {
//  DispatchQueue.global(qos: .userInitiated) .async {
//    // 使用 wait block住当前线程 所以 这里需要使用一个后台线程以免阻塞主线程
//    var storedError: NSError?
//    let downloadGroup = DispatchGroup() // 创建一个 dispatch group
//    for address in [overlyAttachedGirlfriendURLString,
//                    successKidURLString,
//                    lotsOfFacesURLString] {
//                      
//                      let url = URL(string: address)
//                      
//                      downloadGroup.enter()  // 通知 group 有个任务开始 enter和leave必须成对出现  否则 app将会crash
//                      
//                      // A download task
//                      let photo = DownloadPhoto(url: url!) {
//                        _, error in
//                        if error != nil {
//                          storedError = error
//                        }
//                        // 通知group 任务完成
//                        downloadGroup.leave()
//                      }
//                      PhotoManager.sharedManager.addPhoto(photo)
//    }
//    downloadGroup.wait() // wait 阻塞当前线程 等待其他任务完成  这里也可指定等待超时时间
//    //      downloadGroup.wait(timeout: DispatchTime.now()+25) // 25s 后超时
//    DispatchQueue.main.async {
//      completion?(storedError)
//    }
//}

//: 下面这种notify的方式 不会阻塞线程

//func downloadPhotosWithCompletion(_ completion: BatchPhotoDownloadingCompletionClosure?) {
//  var storedError: NSError?
//  let downloadGroup = DispatchGroup()
//  for address in [overlyAttachedGirlfriendURLString,
//                  successKidURLString,
//                  lotsOfFacesURLString] {
//                    let url = URL(string: address)
//                    
//                    downloadGroup.enter()
//                    let photo = DownloadPhoto(url: url!) {
//                      _, error in
//                      if error != nil {
//                        storedError = error
//                      }
//                      downloadGroup.leave()
//                    }
//                    PhotoManager.sharedManager.addPhoto(photo)
//  }
//  downloadGroup.notify(queue: DispatchQueue.main){
//    completion?(storedError)
//  }
//}

//: for 循环

DispatchQueue.concurrentPerform(iterations: 8) { (i) in
  print(i) // 0-7
}

let block = DispatchWorkItem {
}
DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: block)

block.cancel() // 取消任务
print(block.isCancelled)




