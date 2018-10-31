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
#import <objc/runtime.h>
#import <RSSwizzle.h>

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

- (instancetype)initWithObserved:(NSObject *)observed {
    if (self = [super init]) {
        _observed = observed;
    }
    return self;
}

- (void)dealloc {
    NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  self.kvoInfoMap.copy;
    for (NSString *keyPath in kvoinfos.allKeys) {
        for (NSObject *observer in kvoinfos[keyPath].copy) {
            [ZXCrashProtection stop];
            [_observed removeObserver:observer forKeyPath:keyPath];
            [ZXCrashProtection start];
            [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"KVO - %@: removeObserver: %@ forKeyPath: %@", _observed, observer, keyPath] errorType:ZXCrashProtectionTypeKVO];
        }
    }
    _observed = nil;
    [self.kvoInfoMap removeAllObjects];
}

@end
