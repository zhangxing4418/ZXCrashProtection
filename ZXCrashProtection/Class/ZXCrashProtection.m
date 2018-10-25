//
//  ZXCrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ZXCrashProtection.h"
#import "NSObject+Unrecoginzed.h"
#import "ContainerCrashProtection.h"
#import "StringCrashProtection.h"
#import "ZXRecord.h"

static BOOL __isWorking;

@implementation ZXCrashProtection

+ (BOOL)isWorking {
    return __isWorking;
}

+ (void)recordErrorDelegate:(id<ZXCrashProtectionProtocol>)delegate {
    [ZXRecord recordErrorDelegate:delegate];
}

+ (void)startWithProtectionType:(ZXCrashProtectionType)type {
    if (type & ZXCrashProtectionTypeAll) {
        [NSObject launchUnrecoginzedSelectorProtection];
        [ContainerCrashProtection launchContainerCrashProtection];
        [StringCrashProtection launchStringCrashProtection];
    }
    if (type & ZXCrashProtectionTypeUnrecognizedSelector) {
        [NSObject launchUnrecoginzedSelectorProtection];
    }
    if (type & ZXCrashProtectionTypeKVO) {
        
    }
    if (type & ZXCrashProtectionTypeNotification) {
        
    }
    if (type & ZXCrashProtectionTypeTimer) {
        
    }
    if (type & ZXCrashProtectionTypeContainer) {
        [ContainerCrashProtection launchContainerCrashProtection];
    }
    if (type & ZXCrashProtectionTypeString) {
        [StringCrashProtection launchStringCrashProtection];
    }
}

+ (void)start {
    [ZXCrashProtection startWithProtectionType:ZXCrashProtectionTypeAll];
    __isWorking = YES;
}

+ (void)stop {
    __isWorking = NO;
}

@end
