#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>
#import <objc/runtime.h>

// 声明 sub_7E6C 函数
void sub_7E6C(void);

// 初始化函数
void InitFunc_0() {
    // 延迟 1 秒后执行 block
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)); // 延迟时间
    dispatch_after(when, dispatch_get_main_queue(), ^{
        NSLog(@"InitFunc_0 executed block on main queue"); // 使用 NSLog 替代 %log
        sub_7E6C(); // 调用 sub_7E6C
    });
}

// Hook sub_7E6C 函数
void sub_7E6C() {
    // 获取 STUser 类
    Class STUserClass = objc_getClass("STUser");
    if (STUserClass) {
        // 调用 STUser 的 current 方法
        id currentUser = [STUserClass performSelector:@selector(current)];
        
        // 设置用户计划 (调用 setPlan: 方法，参数为 nil)
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

// 将 InitFunc_0 在应用启动时调用
%ctor {
    InitFunc_0();
}

// 钩取 STUser 类的方法
%hook STUser
// 在此处添加需要钩取的函数或方法
%end
