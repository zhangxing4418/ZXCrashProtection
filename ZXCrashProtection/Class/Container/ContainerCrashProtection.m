//
//  ContainerCrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ContainerCrashProtection.h"
#import "NSNull+CrashProtection.h"
#import "NSArray+CrashProtection.h"
#import "NSMutableArray+CrashProtection.h"
#import "NSDictionary+CrashProtection.h"
#import "NSMutableDictionary+CrashProtection.h"
#import "NSCache+CrashProtection.h"

@implementation ContainerCrashProtection

+ (void)launchContainerCrashProtection {
    [NSNull launchNSNullCrashProtection];
    [NSArray launchNSArrayCrashProtection];
    [NSMutableArray launchNSMutableArrayCrashProtection];
    [NSDictionary launchNSDictionaryCrashProtection];
    [NSMutableDictionary launchNSMutableDictionaryCrashProtection];
    [NSCache launchNSCacheCrashProtection];
}

@end
