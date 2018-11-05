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
#import <RSSwizzle/RSSwizzle.h>
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
        [NSObject zx_swizzle_removeObserverForKeyPath];
        [NSObject zx_swizzle_observeValueForKeyPathOfObjectChangeContext];
//        [NSObject zx_swizzle_dealloc];
    });
}

+ (void)zx_swizzle_addObserverForKeyPathOptionsContext {
    RSSwizzleInstanceMethod([NSObject class], @selector(addObserver:forKeyPath:options:context:), RSSWReturnType(void), RSSWArguments(NSObject *observer, NSString *keyPath, NSKeyValueObservingOptions options, void *context), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (object_getClass(observer) == objc_getClass("ZXKVODelegate")) {
                RSSWCallOriginal(observer, keyPath, options, context);
                return;
            }
            ZXKVODelegate *delegate = [self kvoDelegate];
            if (!delegate) {
                delegate = [[ZXKVODelegate alloc] initWithObserved:self];
                [self setkvoDelegate:delegate];
            }
            NSHashTable<NSObject *> *hashTable = delegate.kvoInfoMap[keyPath];
            NSHashTable<NSString *> *recordHashTable = delegate.observerRecordMap[keyPath];
            NSString *observerFlag = [NSString stringWithFormat:@"%@", observer];
            if (recordHashTable.count == 0) {
                recordHashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsStrongMemory capacity:0];
                [recordHashTable addObject:observerFlag];
                delegate.observerRecordMap[keyPath] = recordHashTable;
                [self setkvoDelegate:delegate];
            }else {
                if (![recordHashTable containsObject:observerFlag]) {
                    [recordHashTable addObject:observerFlag];
                }
            }
            if (hashTable.count == 0) {
                hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
                [hashTable addObject:observer];
                delegate.kvoInfoMap[keyPath] = hashTable;
                [self setkvoDelegate:delegate];
                RSSWCallOriginal(observer, keyPath, options, context);
            }else {
                if ([hashTable containsObject:observer]) {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"target %@, observer %@, keyPath %@: KVO add Observer too many times.", NSStringFromClass([self class]), NSStringFromClass([observer class]), keyPath] errorType:ZXCrashProtectionTypeKVO];
                }else {
                    [hashTable addObject:observer];
                    RSSWCallOriginal(observer, keyPath, options, context);
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
            if (object_getClass(observer) == objc_getClass("ZXKVODelegate")) {
                RSSWCallOriginal(observer, keyPath);
                return;
            }
            ZXKVODelegate *delegate = [self kvoDelegate];
            NSHashTable<NSObject *> *hashTable = delegate.kvoInfoMap[keyPath];
            NSHashTable<NSString *> *recordHashTable = delegate.observerRecordMap[keyPath];
            if ([hashTable allObjects].count == 0 && [recordHashTable allObjects].count != 0) {
                RSSWCallOriginal(observer, keyPath);
                return;
            }
            if ([hashTable containsObject:observer]) {
                [hashTable removeObject:observer];
                RSSWCallOriginal(observer, keyPath);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"Cannot remove an observer %@ for key path %@ because it is not registered as an observer.", observer, keyPath] errorType:ZXCrashProtectionTypeKVO];
            }
            if (hashTable.count == 0) {
                [delegate.kvoInfoMap removeObjectForKey:keyPath];
            }
        }else {
            RSSWCallOriginal(observer, keyPath);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_observeValueForKeyPathOfObjectChangeContext {
    RSSwizzleInstanceMethod([NSObject class], @selector(observeValueForKeyPath:ofObject:change:context:), RSSWReturnType(void), RSSWArguments(NSString *keyPath, id object, NSDictionary<NSKeyValueChangeKey, id> *change, void *context), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            ZXKVODelegate *delegate = [object kvoDelegate];
            NSHashTable<NSObject *> *hashTable = delegate.kvoInfoMap[keyPath];
            for (NSObject *observer in hashTable) {
                @try {
                    ((__typeof(originalImplementation_))[swizzleInfo getOriginalImplementation])(observer, @selector(observeValueForKeyPath:ofObject:change:context:), keyPath, object, change, context);
                } @catch (NSException *exception) {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"%@: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.", observer] errorType:ZXCrashProtectionTypeKVO];
                }
            }
        }else {
            RSSWCallOriginal(keyPath, object, change, context);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_dealloc {
    RSSwizzleInstanceMethod([NSObject class], NSSelectorFromString(@"dealloc"), RSSWReturnType(void), RSSWArguments(), RSSWReplacement({
        ZXKVODelegate *delegate = [self kvoDelegate];
        if (delegate) {
            NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  delegate.kvoInfoMap.copy;
            for (NSString *keyPath in kvoinfos.allKeys) {
                for (NSObject *observer in kvoinfos[keyPath].copy) {
                    [self removeObserver:observer forKeyPath:keyPath];
                    NSLog(@"%@: removeObserver: %@ forKeyPath: %@", self, observer, keyPath);
                }
            }
        }
        RSSWCallOriginal();
    }), RSSwizzleModeAlways, nil);
}

@end
