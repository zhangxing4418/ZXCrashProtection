//
//  KVOObserverInfo.h
//  ZXCrashProtection
//
//  Created by bug on 2018/11/6.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSHashTable (observerInfo)

- (BOOL)containsObserver:(NSObject *)observer;
- (void)addObserver:(NSObject *)observer;
- (void)removeObserver:(NSObject *)observer;
- (BOOL)verifyIntegrityWithObserver:(NSObject *)observer;

@end

@interface KVOObserverInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, assign, readonly) NSUInteger observerHash;

- (instancetype)initWithObserver:(NSObject *)observer;

@end

NS_ASSUME_NONNULL_END
