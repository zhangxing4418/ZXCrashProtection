//
//  NSNull+CrashProtection.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNull(CrashProtection)

+ (void)launchNSNullCrashProtection;

@end

NS_ASSUME_NONNULL_END
