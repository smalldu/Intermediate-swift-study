
为什么要用到Router去做跳转：解耦、方便

像底下这种代码可能写了很多很多遍了，尤其是在项目中某个页面入口很多的情况下。

```swift
let xx = XX()

...

let vc = XXXViewController(xx:xxx)
self.navigationController?.pushViewController(vc, animated: true)
```

尤其是公司要开发多个项目，对模块进行了拆分，组件化的模式需要中间一个Router去决定跳转到那个模块的页面，而不是在每个页面都import XX 耦合非常严重。

浏览了下GitHub上的两个库，都不是很满意 

- [Router](https://github.com/anpufeng/Router/blob/master/Router/Router.swift) 比较Swifty,但是耦合比较严重，实现了很多暂时不需要的功能，每个VC需要将自己当成字符串告诉Router , 还要告诉当前的navigation , 使用了`NSClassFromString`根据字符创建的 AnyClass 。比较繁琐-- 但是还有很好的思想可以借鉴的
- [FNUrlRoute](https://github.com/Fnoz/FNUrlRoute) 通过url形式跳转，看起来挺不错，仔细看下代码，首先`AppDelegate`要先用字符串和VC进行映射，每个VC要传入`[String:AnyObject]？` 进行初始化，这个把VC的创建都限制死了。绝对用不了呀，还有那么多人star ... 

*** 

说完他们的不足，首先来看下我们这个Router设计要求

- 解耦：调用者不知道VC的名字 
- 不要用字符串，字符串容易出错
- 不能限制初始化方法
- 调用者应该非常简洁

那么不使用字符串很容易想到就是用枚举来替代，枚举中也可能映射VC呀，而且不用在`AppDelegate`中注册，不能限制初始化方法我们就用params字典去映射 [Router](https://github.com/anpufeng/Router/blob/master/Router/Router.swift) 里面的方式 感觉比较好 ， 自己肯定是知道自己怎么初始化的， 用协议的方式比用强迫字典初始化好很多 

```
public typealias  RouterParameter = [String: Any]
public protocol Routable {
  /**
   类的初始化方法
   - params 传参字典
   */
  static func initWithParams(params: RouterParameter?) -> UIViewController
}
```


我们跳转只需要知道哪个VC要传的参数，这个都交给枚举就可以了，为了项目路径映射和跳转解耦，用一个协议

```
public protocol RouterPathable {
  var any: AnyClass { get }
  var params: RouterParameter? { get }
}
```

其他就交给跳转了

```swift
open class func open(_ path:RouterPathable , present: Bool = false , animated: Bool = true , presentComplete: (()->Void)? = nil){
    if let cls = path.any as? Routable.Type {
      let vc = cls.initWithParams(params: path.params)
      vc.hidesBottomBarWhenPushed = true
      let topViewController = RouterUtils.currentTopViewController()
      if topViewController?.navigationController != nil && !present {
        topViewController?.navigationController?.pushViewController(vc, animated: animated)
      }else{
        topViewController?.present(vc, animated: animated , completion: presentComplete)
      }
    }
  }
```

其中有用到一个工具方法是获取最上层的vc好进行跳转，具体代码可以去GitHub下载

使用：  需要使用router进行跳转的都要事先`Routable` 接口，调用者不需要 

无参数 

```
class AVC: UIViewController, Routable{
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.red
  }

  static func initWithParams(params: RouterParameter?) -> UIViewController {
    return AVC()
  }
}
```

有参数

```

struct Demo {
  var name: String
  var id: Int
}

class RVC: UIViewController {
  let demo:Demo
  init(demo:Demo) {
    self.demo = demo
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    navigationItem.title = demo.name
  }
}

extension RVC: Routable {
  static func initWithParams(params: RouterParameter?) -> UIViewController {
    guard let demo = params?["demo"] as? Demo else {
      fatalError("params is wrong")
    }
    let rvc = RVC(demo: demo)
    return rvc
  }
}
```

路径映射： 

比如上面的vc都是其他模块的，那么只有这个映射的枚举需要引入其他模块，调用者不需要 , 下面展示三个vc的路径映射 

```
enum RouterPath: RouterPathable {
  case avc
  case bvc(String)
  case rvc(Demo)
  
  var any: AnyClass {
    switch self {
    case .avc:
      return AVC.self
    case .bvc:
      return BVC.self
    case .rvc:
      return RVC.self
    }
  }
  
  var params: RouterParameter? {
    switch self {
    case .bvc(let name):
      return ["name":name]
    case .rvc(let demo):
      return ["demo":demo]
    default:
      return nil
    }
  }
}
```


只要实现 `RouterPathable` 都可以 ，如果需要映射的vc特别多 ， 也可以分组管理。


调用者就很方便了
```
Router.open(RouterPath.avc)
```

```
let demo = Demo(name: "RVC title", id: 1)
Router.open(RouterPath.rvc(demo))
```

或者present

```
Router.open(RouterPath.bvc("BVC title"), present: true)
```

项目地址： [SwiftyRouter](https://github.com/smalldu/SwiftyRouter)















