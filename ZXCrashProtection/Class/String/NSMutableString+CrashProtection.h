//
//  NSMutableString+CrashProtection.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/25.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString(CrashProtection)

+ (void)launchNSMutableStringCrashProtection;

@end

NS_ASSUME_NONNULL_END
