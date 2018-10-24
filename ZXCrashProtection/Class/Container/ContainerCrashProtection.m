//
//  ContainerCrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ContainerCrashProtection.h"
#import "NSNull+CrashProtection.h"

@implementation ContainerCrashProtection

+ (void)launchContainerCrashProtection {
    [NSNull launchNSNullCrashProtection];
}

@end
