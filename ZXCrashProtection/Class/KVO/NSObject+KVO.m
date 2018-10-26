//
//  NSObject+KVO.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/26.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSObject+KVO.h"
#import "ZXKVODelegate.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle.h>
#import <objc/runtime.h>

@interface NSObject (KVODelegate)

@property (nonatomic, strong) ZXKVODelegate *kvoDelegate;

@end

@implementation NSObject(KVO)

- (void)setkvoDelegate:(ZXKVODelegate *)kvoDelegate {
    objc_setAssociatedObject(self, @selector(kvoDelegate), kvoDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZXKVODelegate *)kvoDelegate {
    return objc_getAssociatedObject(self, @selector(kvoDelegate));
}

+ (void)launchKVOCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject zx_swizzle_addObserverForKeyPathOptionsContext];
//        [NSObject zx_swizzle_removeObserverForKeyPath];
    });
}

+ (void)zx_swizzle_addObserverForKeyPathOptionsContext {
    RSSwizzleInstanceMethod([NSObject class], @selector(addObserver:forKeyPath:options:context:), RSSWReturnType(void), RSSWArguments(NSObject *observer, NSString *keyPath, NSKeyValueObservingOptions options, void *context), RSSWReplacement({
        NSLog(@"xxxxxxx");
        if ([ZXCrashProtection isWorking]) {
            if (object_getClass(observer) == objc_getClass("ZXKVODelegate") ) {
                RSSWCallOriginal(observer, keyPath, options, context);
                NSLog(@"run1");
                return;
            }
            ZXKVODelegate *delegate = [self kvoDelegate];
            if (!delegate) {
                delegate = [[ZXKVODelegate alloc] initWithObserved:self];
                [self setkvoDelegate:delegate];
            }
            NSHashTable<NSObject *> *hashTable = delegate.kvoInfoMap[keyPath];
            if (hashTable.count == 0) {
                hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
                [hashTable addObject:observer];
                delegate.kvoInfoMap[keyPath] = hashTable;
                [self setkvoDelegate:delegate];
                RSSWCallOriginal(observer, keyPath, options, context);
                NSLog(@"run2");
            }else {
                if ([hashTable containsObject:observer]) {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"target %@, observer %@, keyPath %@: KVO add Observer too many times.", NSStringFromClass([self class]), NSStringFromClass([observer class]), keyPath] errorType:ZXCrashProtectionTypeKVO];
                }else {
                    [hashTable addObject:observer];
                    RSSWCallOriginal(observer, keyPath, options, context);
                    NSLog(@"run3");
                }
            }
        }else {
            RSSWCallOriginal(observer, keyPath, options, context);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_removeObserverForKeyPath {
    RSSwizzleInstanceMethod([NSObject class], @selector(removeObserver:forKeyPath:), RSSWReturnType(void), RSSWArguments(NSObject *observer, NSString *keyPath), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            
        }else {
            RSSWCallOriginal(observer, keyPath);
        }
    }), RSSwizzleModeAlways, nil);
}

@end
