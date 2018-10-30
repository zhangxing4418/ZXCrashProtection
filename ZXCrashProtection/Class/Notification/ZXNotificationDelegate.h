//
//  ZXNotificationDelegate.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/30.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNotificationDelegate : NSObject

@property (nonatomic, assign) BOOL needRemove;

- (instancetype)initWithObserver:(id)observer;

@end

NS_ASSUME_NONNULL_END
