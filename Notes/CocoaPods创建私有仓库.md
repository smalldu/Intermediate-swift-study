## 安装 cocoapods

```
sudo gem install cocoapods
```

```
pod setup
```
怎么使用不在讨论范围 

```
pod repo
```

应该只有一个master，是公开的

## 添加一个repo 

```
pod repo add #repo_name# https://github.com/yourname/specs.git
```

这时候`pod repo` 应该可以看到两个了 

## 创建项目 

利用 `pod` 提供的工具创建一个 `spec` 项目 

```
pod lib create #your_project_name#
```

会又一些选项需要你去填写，填写完后就会自动生成一个项目

需要配置 `#project_name#.podspec`

```ruby
# 资源文件
  s.resource = '#project_name#/Assets/**/*'
# code 文件
  s.source_files = '#project_name#/Classes/**/*'
  # 其他配置
```

## 验证项目 

tag 需要和 s.version 相同。 
提交tag 

执行下面语句验证 

```ruby
pod spec lint --verbose  --allow-warnings
```

这块有巨坑  ， 如果你有项目依赖自己的私有库，这里需要指定source

```ruby
pod spec lint --sources='私有仓库repo地址,https://github.com/CocoaPods/Specs'
```


根据提示修改 

## 引用自己或第三方的framework或.a文件时

```
s.ios.vendored_frameworks = "xxx/**/*.framework"
s.ios.vendored_libraries = "xxx/**/*.a”
```


## 提交项目到私有repo

```ruby
pod repo push #your_repo_name# #your_project_name#.podspec --verbose --allow-warnings
```

如果你有项目依赖自己的私有库，这里需要指定source

```ruby
pod repo push 本地repo名 podspec名 --sources='私有仓库repo地址,https://github.com/CocoaPods/Specs'
```

最后

```ruby
 pod spec lint --allow-warnings
```

在需要引入的地方 指定source

```
source 'https://github.com/yourname/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'
```


参考 ： 

https://guides.cocoapods.org/making/private-cocoapods.html
https://guides.cocoapods.org/syntax/podfile.html#source
http://www.jianshu.com/p/1e5927eeb341



***
over 






