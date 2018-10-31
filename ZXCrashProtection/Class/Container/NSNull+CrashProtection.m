//
//  NSNull+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSNull+CrashProtection.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation NSNull(CrashProtection)

+ (void)launchNSNullCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSNull zx_swizzle_forwardingTargetForSelector];
    });
}

+ (void)zx_swizzle_forwardingTargetForSelector {
    RSSwizzleInstanceMethod([NSNull class], @selector(forwardingTargetForSelector:), RSSWReturnType(id), RSSWArguments(SEL aSelector), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            [ZXRecord recordNoteErrorWithReason:@"-[NSNull objectForKey:]: unrecognized selector" errorType:ZXCrashProtectionTypeContainer];
            
            static NSArray *sTmpOutput = nil;
            if (sTmpOutput == nil) {
                sTmpOutput = @[@"", @0, @[], @{}];
            }
            for (id tmpObj in sTmpOutput) {
                if ([tmpObj respondsToSelector:aSelector]) {
                    return tmpObj;
                }
            }
        }
        return RSSWCallOriginal(aSelector);
    }), RSSwizzleModeAlways, nil);
}

@end
