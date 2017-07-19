1. iOS UITextView 光标不在第一行，不在顶部的问题

```
self.automaticallyAdjustsScrollViewInsets = false
```

2. 纯函数 (Pure Function) 是指一个函数如果有相同的输入，则它产生相同的输出。

datasource 分离出vc 
```
class TableViewControllerDataSource: NSObject, UITableViewDataSource {

    var todos: [String]
    weak var owner: TableViewController?
    
    init(todos: [String], owner: TableViewController?) {
        self.todos = todos
        self.owner = owner
    }
    
    //...
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //...
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseId, for: indexPath) as! TableViewInputCell
            cell.delegate = owner
            return cell
    }
}
```




