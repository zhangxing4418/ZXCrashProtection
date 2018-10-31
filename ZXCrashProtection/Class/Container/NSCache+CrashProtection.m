//
//  NSCache+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/24.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSCache+CrashProtection.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation NSCache(CrashProtection)

+ (void)launchNSCacheCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSCache zx_swizzle_setObjectForKey];
    });
}

+ (void)zx_swizzle_setObjectForKey {
    RSSwizzleInstanceMethod([NSCache class], @selector(setObject:forKey:), RSSWReturnType(void), RSSWArguments(id obj, id key), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (obj) {
                RSSWCallOriginal(obj, key);
            }else if (!obj && key) {
                [ZXRecord recordNoteErrorWithReason:@"-[NSCache setObject:forKey:]: attempt to insert nil value" errorType:ZXCrashProtectionTypeContainer];
            }
        }else {
            RSSWCallOriginal(obj, key);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_setObjectForKeyCost {
    RSSwizzleInstanceMethod([NSCache class], @selector(setObject:forKey:cost:), RSSWReturnType(void), RSSWArguments(id obj, id key, NSUInteger g), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (obj) {
                RSSWCallOriginal(obj, key, g);
            }else if (!obj && key) {
                [ZXRecord recordNoteErrorWithReason:@"-[NSCache setObject:forKey:cost:]: attempt to insert nil value" errorType:ZXCrashProtectionTypeContainer];
            }
        }else {
            RSSWCallOriginal(obj, key, g);
        }
    }), RSSwizzleModeAlways, nil);
}

@end
