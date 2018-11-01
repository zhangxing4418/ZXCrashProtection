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
#import "NSObject+KVO.h"
#import "NSObject+Notification.h"
#import "NSTimer+CrashProtection.h"
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
    if (type & ZXCrashProtectionTypeUnrecognizedSelector) {
        [NSObject launchUnrecoginzedSelectorProtection];
    }
    if (type & ZXCrashProtectionTypeKVO) {
        [NSObject launchKVOCrashProtection];
    }
    if (type & ZXCrashProtectionTypeNotification) {
        [NSObject launchNotificationCrashProtection];
    }
    if (type & ZXCrashProtectionTypeTimer) {
        [NSTimer launchNSTimerCrashProtection];
    }
    if (type & ZXCrashProtectionTypeContainer) {
        [ContainerCrashProtection launchContainerCrashProtection];
    }
    if (type & ZXCrashProtectionTypeString) {
        [StringCrashProtection launchStringCrashProtection];
    }
    __isWorking = YES;
}

+ (void)start {
    [ZXCrashProtection startWithProtectionType:ZXCrashProtectionTypeAll];
}

+ (void)stop {
    __isWorking = NO;
}

@end
