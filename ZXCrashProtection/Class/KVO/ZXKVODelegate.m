//
//  ZXKVODelegate.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/26.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ZXKVODelegate.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import "KVOObserverInfo.h"
#import <objc/runtime.h>
#import <RSSwizzle/RSSwizzle.h>

@interface ZXKVODelegate () {
    __unsafe_unretained NSObject *_observed;
}

@end

@implementation ZXKVODelegate

- (NSMutableDictionary<NSString *, NSHashTable <NSObject *>*> *)kvoInfoMap {
    if (!_kvoInfoMap) {
        _kvoInfoMap = @{}.mutableCopy;
    }
    return _kvoInfoMap;
}

//- (NSMutableDictionary<NSString *, NSHashTable <NSString *>*> *)observerRecordMap {
//    if (!_observerRecordMap) {
//        _observerRecordMap = @{}.mutableCopy;
//    }
//    return _observerRecordMap;
//}

- (instancetype)initWithObserved:(NSObject *)observed {
    if (self = [super init]) {
        _observed = observed;
    }
    return self;
}

- (void)dealloc {
    @autoreleasepool {
        NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  self.kvoInfoMap.copy;
        for (NSString *keyPath in kvoinfos.allKeys) {
            NSHashTable *hashTable = kvoinfos[keyPath].copy;
            for (KVOObserverInfo *observerInfo in hashTable) {
                if (observerInfo.observerHash == observerInfo.observer.hash) {
                    [ZXCrashProtection stop];
                    [_observed removeObserver:observerInfo.observer forKeyPath:keyPath];
                    [ZXCrashProtection start];
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"KVO - %@: removeObserver: %@ forKeyPath: %@", _observed, observerInfo.observer, keyPath] errorType:ZXCrashProtectionTypeKVO];
                }
            }
        }
    }
}

@end
