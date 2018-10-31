//
//  NSMutableDictionary+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/24.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSMutableDictionary+CrashProtection.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation NSMutableDictionary(CrashProtection)

+ (void)launchNSMutableDictionaryCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSMutableDictionary zx_swizzle_setObjectForKey];
        [NSMutableDictionary zx_swizzle_setObjectForKeyedSubscript];
        [NSMutableDictionary zx_swizzle_removeObjectForKey];
    });
}

+ (void)zx_swizzle_setObjectForKey {
    Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
    RSSwizzleInstanceMethod(dictionaryM, @selector(setObject:forKey:), RSSWReturnType(void), RSSWArguments(id anObject, id aKey), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (anObject && aKey) {
                RSSWCallOriginal(anObject, aKey);
            }else if (!anObject) {
                [ZXRecord recordNoteErrorWithReason:@"-[__NSDictionaryM setObject:forKey:]: object cannot be nil" errorType:ZXCrashProtectionTypeContainer];
            }else {
                [ZXRecord recordNoteErrorWithReason:@"-[__NSDictionaryM setObject:forKey:]: key cannot be nil" errorType:ZXCrashProtectionTypeContainer];
            }
        }else {
            RSSWCallOriginal(anObject, aKey);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_setObjectForKeyedSubscript {
    Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
    RSSwizzleInstanceMethod(dictionaryM, @selector(setObject:forKeyedSubscript:), RSSWReturnType(void), RSSWArguments(id obj, id key), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (key) {
                RSSWCallOriginal(obj, key);
            }else {
                [ZXRecord recordNoteErrorWithReason:@"-[__NSDictionaryM setObject:forKeyedSubscript:]: key cannot be nil" errorType:ZXCrashProtectionTypeContainer];
            }
        }else {
            RSSWCallOriginal(obj, key);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_removeObjectForKey {
    Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
    RSSwizzleInstanceMethod(dictionaryM, @selector(removeObjectForKey:), RSSWReturnType(void), RSSWArguments(id aKey), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (aKey) {
                RSSWCallOriginal(aKey);
            }else {
                [ZXRecord recordNoteErrorWithReason:@"-[__NSDictionaryM removeObjectForKey:]: key cannot be nil" errorType:ZXCrashProtectionTypeContainer];
            }
        }else {
            RSSWCallOriginal(aKey);
        }
    }), RSSwizzleModeAlways, nil);
}

@end
