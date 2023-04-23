//
//  NSObject+Unrecoginzed.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSObject+Unrecoginzed.h"
#import "ZXCrashProtection.h"
#import "ZXStubObject.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation NSObject(Unrecoginzed)

+ (void)launchUnrecoginzedSelectorProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject zx_swizzle_forwardingTargetForSelector];
    });
}

+ (void)zx_swizzle_forwardingTargetForSelector {
    RSSwizzleInstanceMethod([NSObject class], @selector(forwardingTargetForSelector:), RSSWReturnType(id), RSSWArguments(SEL aSelector), RSSWReplacement({
        BOOL isWorking = [ZXCrashProtection isWorking];
        if (isWorking) {
            BOOL aBool = [self respondsToSelector:aSelector];
            NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
            if (aBool || signature) {
                return RSSWCallOriginal(aSelector);
            }else {
                [ZXRecord recordNoteErrorWithReason:@"unrecognized selector" errorType:ZXCrashProtectionTypeUnrecognizedSelector];
                ZXStubObject *stub = [ZXStubObject shareInstance];
                [stub addFunc:aSelector];
                return stub;
            }
        }else {
            return RSSWCallOriginal(aSelector);
        }
        
    }), RSSwizzleModeAlways, nil)
}

@end
