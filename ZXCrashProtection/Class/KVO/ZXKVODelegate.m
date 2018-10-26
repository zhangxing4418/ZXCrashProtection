//
//  ZXKVODelegate.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/26.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ZXKVODelegate.h"

@interface ZXKVODelegate ()

@property (nonatomic, strong) NSObject *observed;

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
        self.observed = observed;
    }
    return self;
}

@end
