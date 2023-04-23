//
//  KVOObserverInfo.m
//  ZXCrashProtection
//
//  Created by bug on 2018/11/6.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "KVOObserverInfo.h"

@implementation NSHashTable (observerInfo)

- (BOOL)containsObserver:(NSObject *)observer {
    for (KVOObserverInfo *observerInfo in self) {
        if ([observerInfo.observer isEqual:observer]) {
            return YES;
        }
    }
    return NO;
}

- (void)addObserver:(NSObject *)observer {
    if (![self containsObserver:observer]) {
        [self addObject: [[KVOObserverInfo alloc] initWithObserver:observer]];
    }
}

- (void)removeObserver:(NSObject *)observer {
    for (KVOObserverInfo *observerInfo in self) {
        if ([observerInfo.observer isEqual:observer]) {
            [self removeObject:observerInfo];
            break;
        }
    }
}

- (BOOL)verifyIntegrityWithObserver:(NSObject *)observer {
    for (KVOObserverInfo *observerInfo in self) {
        if (observerInfo.observerHash == observer.hash) {
            if ([observerInfo.observer isEqual:observer]) {
                return YES;
            }else {
                [self removeObject:observerInfo];
                return NO;
            }
        }
    }
    return YES;
}

@end

@implementation KVOObserverInfo

- (instancetype)initWithObserver:(NSObject *)observer {
    if (self = [super init]) {
        self.observer = observer;
    }
    return self;
}

- (void)setObserver:(NSObject *)observer {
    _observer = observer;
    _observerHash = observer.hash;
}

@end
