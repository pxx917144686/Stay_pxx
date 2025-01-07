// 作者: pxx

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
