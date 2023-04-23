//
//  ZXKVODelegate.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/26.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXKVODelegate : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable <NSObject *>*> *kvoInfoMap;
//@property (nonatomic, strong) NSMutableDictionary<NSString *, NSHashTable <NSString *>*> *observerRecordMap;

- (instancetype)initWithObserved:(NSObject *)observed;

@end

NS_ASSUME_NONNULL_END
