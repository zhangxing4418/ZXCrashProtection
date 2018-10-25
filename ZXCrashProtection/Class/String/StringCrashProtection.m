//
//  StringCrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/25.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "StringCrashProtection.h"
#import "NSString+CrashProtection.h"
#import "NSMutableString+CrashProtection.h"

@implementation StringCrashProtection

+ (void)launchStringCrashProtection {
    [NSString launchNSStringCrashProtection];
    [NSMutableString launchNSMutableStringCrashProtection];
}

@end
