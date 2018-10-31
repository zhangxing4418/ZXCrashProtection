//
//  NSDictionary+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/24.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSDictionary+CrashProtection.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation NSDictionary(CrashProtection)

+ (void)launchNSDictionaryCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSDictionary zx_swizzle_dictionaryWithObjectsForKeysCount];
    });
}

+ (void)zx_swizzle_dictionaryWithObjectsForKeysCount {
    RSSwizzleClassMethod([self class], @selector(dictionaryWithObjects:forKeys:count:), RSSWReturnType(id), RSSWArguments(const id *objects, const id *keys, NSUInteger cnt), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            id instance = nil;
            @try {
                instance = RSSWCallOriginal(objects, keys, cnt);
            } @catch (NSException *exception) {
                [ZXRecord recordNoteErrorWithReason:exception.reason errorType:ZXCrashProtectionTypeContainer];
                NSUInteger index = 0;
                id  _Nonnull __unsafe_unretained newObjects[cnt];
                id  _Nonnull __unsafe_unretained newkeys[cnt];
                for (int i = 0; i < cnt; i++) {
                    if (objects[i] && keys[i]) {
                        newObjects[index] = objects[i];
                        newkeys[index] = keys[i];
                        index++;
                    }
                }
                instance = RSSWCallOriginal(newObjects, newkeys, index);
            } @finally {
                return instance;
            }
        }else {
            return RSSWCallOriginal(objects, keys, cnt);
        }
    }));
}

@end
