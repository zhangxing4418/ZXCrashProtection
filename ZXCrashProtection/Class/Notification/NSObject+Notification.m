//
//  NSObject+Notification.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/30.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSObject+Notification.h"
#import "ZXNotificationDelegate.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>
#import <objc/runtime.h>

@interface NSObject (NotificationDelegate)

@property (nonatomic, strong) ZXNotificationDelegate *notificationDelegate;

@end

@implementation NSObject(Notification)

- (void)setNotificationDelegate:(ZXNotificationDelegate *)notificationDelegate {
    objc_setAssociatedObject(self, @selector(notificationDelegate), notificationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZXNotificationDelegate *)notificationDelegate {
    return objc_getAssociatedObject(self, @selector(notificationDelegate));
}

+ (void)launchNotificationCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject zx_swizzle_addObserverSelectorNameObject];
        [NSObject zx_swizzle_removeObserverNameObject];
    });
}

+ (void)zx_swizzle_addObserverSelectorNameObject {
    RSSwizzleInstanceMethod([NSNotificationCenter class], @selector(addObserver:selector:name:object:), RSSWReturnType(void), RSSWArguments(id observer, SEL aSelector, NSNotificationName aName, id anObject), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            ZXNotificationDelegate *delegate = [observer notificationDelegate];
            if (!delegate) {
                delegate = [[ZXNotificationDelegate alloc] initWithObserver:observer];
            }
            delegate.needRemove = YES;
            [observer setNotificationDelegate:delegate];
            RSSWCallOriginal(observer, aSelector, aName, anObject);
        }else {
            RSSWCallOriginal(observer, aSelector, aName, anObject);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_removeObserverNameObject {
    RSSwizzleInstanceMethod([NSNotificationCenter class], @selector(removeObserver:name:object:), RSSWReturnType(void), RSSWArguments(id observer, NSNotificationName aName, id anObject), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            ZXNotificationDelegate *delegate = [observer notificationDelegate];
            delegate.needRemove = NO;
            RSSWCallOriginal(observer, aName, anObject);
        }else {
            RSSWCallOriginal(observer, aName, anObject);
        }
    }), RSSwizzleModeAlways, nil);
}

@end
