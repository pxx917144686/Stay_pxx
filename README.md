<details>
<summary> <-- 打包插件</summary>

[![Preview](./x/编译.png))
</details> 


<details>
<summary> <-- 打包插件 ——> 到项目根目录</summary>

[![Preview](./x/打包.png))
</details>


## 克隆 Theos

```bash
git clone --recursive https://github.com/theos/theos.git
```

将 Theos 的路径添加到环境变量中
```bash
export THEOS=~/theos
export PATH=$THEOS/bin:$PATH
```
重新加载配置
```bash
source ~/.zshrc
```



## 关于. `Objective-C 的头文件引用` 

![Preview](./x/1.png)

## 目录、方法 简单总结概括

下面是一些常见的头文件引用及其简要说明，帮助理解它们在 iOS 和 macOS 开发中的作用。

---

| **方法**                            | **说明**                                                                                     |
|-------------------------------------|----------------------------------------------------------------------------------------------|
| **`#import <UIKit/UIKit.h>`**       | 这是一个常见的头文件引用。UIKit 是一个非常重要的 iOS 开发框架，包含了所有 UI 相关的功能，例如界面组件（如按钮、标签、文本框等）、视图管理、动画、用户交互。 |
| **`#import <dispatch/dispatch.h>`**  | 这是导入 GCD（Grand Central Dispatch）框架的头文件。GCD 是苹果提供的一种多线程技术，用来高效地处理并发任务。在 iOS 和 macOS 中，GCD 是一个常用的工具，用来简化并发编程，提升应用的性能。 |
| **`#import <objc/runtime.h>`**      | 这是导入 Objective-C 运行时的头文件。在 iOS 或 macOS 中，运行时可以用来做很多高级操作，比如动态添加方法、交换方法实现、查询类信息等。 |

---


## 关于. `Tweak.x` 

![Preview](./x/2.png)


## 目录、方法 简单总结概括

结合了 **UIKit**、**GCD**、**运行时编程**，使用了 **Theos** 中的钩子方法，整体实现了高效的 UI 操作与异步任务处理。

---

| **方法**                | **说明**                                                      |
|-------------------------|-------------------------------------------------------------|
| **`#import <UIKit/UIKit.h>`**  | 导入 UIKit 框架，用于 UI 处理。                             |
| **`#import <dispatch/dispatch.h>`** | 导入 GCD 框架，用于异步和延迟执行。                           |
| **`#import <objc/runtime.h>`** | 导入运行时库，用于动态操作类和对象。                              |
| **`InitFunc_0()`**      | 设置了一个延迟任务，在 1 秒后在主线程执行 **`sub_7E6C()`** 函数。      |
| **`sub_7E6C()`**        | 动态获取 **`STUser`** 类，通过运行时机制调用 **`current`** 方法获取当前用户，并尝试调用 **`setPlan:`** 方法。 |
| **`%ctor`**             | 让 **`InitFunc_0`** 在程序启动时自动执行。                       |
| **`%hook STUser`**      | 对 **`STUser`** 类进行钩子操作。                                 |

---






## 关于. `void sub_7E6C(void);` 
```bash
void sub_7E6C(void);
```
作用：声明一个函数，但没有定义具体内容（定义在后面）
     一个自定义的函数，可能在后面用来执行某些操作。

## 关于. `void InitFunc_0() { ... }` 
```bash
void InitFunc_0() {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        NSLog(@"InitFunc_0 executed block on main queue");
        sub_7E6C();
    });
}
```
作用：InitFunc_0 是一个自定义函数
dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));     //  这一行代码是使用 GCD 设置一个延迟的时间（1秒）。

dispatch_time    //   用于计算延迟的时间（这里是 1 秒）。

dispatch_after(when, dispatch_get_main_queue(), ^{ ... });    //  这行代码是将一个任务排入主队列，并延迟 1 秒后执行。

dispatch_get_main_queue()    //  表示将代码放到主线程（UI线程）执行。

NSLog(@"InitFunc_0 executed block on main queue");   //  会在主线程上输出日志，说明延迟任务执行了。

sub_7E6C()   //  InitFunc_0 在 1 秒钟后，会在主线程上执行一个 block，在该 block 中会调用 sub_7E6C() 函数。


## 关于. `void sub_7E6C() { ... }` 
```bash
void sub_7E6C() {
    Class STUserClass = objc_getClass("STUser");
    if (STUserClass) {
        id currentUser = [STUserClass performSelector:@selector(current)];
        if (currentUser) {
            [currentUser performSelector:@selector(setPlan:) withObject:nil];
            NSLog(@"Called setPlan: on STUser");
        } else {
            NSLog(@"STUser current returned nil");
        }
    } else {
        NSLog(@"STUser class not found");
    }
}
```
作用：用来检查是否存在 STUser 类

Class STUserClass = objc_getClass("STUser");    //   通过运行时 API 获取名为 STUser 的类。objc_getClass 是运行时的函数，它根据字符串名称返回一个类的引用。

if (STUserClass)   //  检查 STUser 类是否存在。 

id currentUser = [STUserClass performSelector:@selector(current)];    //   通过动态消息发送，调用 STUser 类的 current 方法，返回一个用户对象。

如果 currentUser 不为 nil，调用 setPlan: 方法，并传递 nil。setPlan: 是一个用于设置用户的 setter 方法。



## 关于. `%ctor { InitFunc_0(); }` 
```bash
%ctor {
    InitFunc_0();
}
```
作用：当APP Stay 执行时，InitFunc_0 会被调用。通过构造函数机制，InitFunc_0 中的延时任务（1 秒后执行）会被触发。（这是 Theos 环境中特有的语法，%ctor 是一个构造函数，表示在某个对象或者类被加载时，自动执行其中的代码。）


## 关于. `%hook STUser` 
```bash
%hook STUser
%end
```
作用：对 STUser 类的钩住操作

这段代码使用 Theos 特有的语法，%hook 是用来钩住，或拦截STUser 类

%hook STUser 表示要对 STUser 类进行修改

%end 结束钩子操作。





<details>
<summary> ——> 完整代码如下</summary>

```objc



#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>
#import <objc/runtime.h>

void sub_7E6C(void);

void InitFunc_0() {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        NSLog(@"InitFunc_0 executed block on main queue");
        sub_7E6C();
    });
}

void sub_7E6C() {
    Class STUserClass = objc_getClass("STUser");
    if (STUserClass) {
        id currentUser = [STUserClass performSelector:@selector(current)];
        if (currentUser) {
            [currentUser performSelector:@selector(setPlan:) withObject:nil];
            NSLog(@"Called setPlan: on STUser");
        } else {
            NSLog(@"STUser current returned nil");
        }
    } else {
        NSLog(@"STUser class not found");
    }
}

%ctor {
    InitFunc_0();
}

%hook STUser
%end

```
