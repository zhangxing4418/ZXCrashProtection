//
//  NSMutableArray+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/24.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSMutableArray+CrashProtection.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation NSMutableArray(CrashProtection)

+ (void)launchNSMutableArrayCrashProtection{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSMutableArray zx_swizzle_nSArrayM_objectAtIndex];
        [NSMutableArray zx_swizzle_nSArrayM_objectAtIndexedSubscript];
        [NSMutableArray zx_swizzle_nSArrayM_setObjectAtIndexedSubscript];
        [NSMutableArray zx_swizzle_nSArrayM_removeObjectAtIndex];
        [NSMutableArray zx_swizzle_nSArrrayM_insertObjectAtIndex];
    });
}

+ (void)zx_swizzle_nSArrayM_objectAtIndex {
    Class arrayMClass = NSClassFromString(@"__NSArrayM");
    RSSwizzleInstanceMethod(arrayMClass, @selector(objectAtIndex:), RSSWReturnType(id), RSSWArguments(NSUInteger index), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self count] > index) {
                return RSSWCallOriginal(index);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ objectAtIndex:]: index %ld beyond bounds [0 .. %ld]", NSStringFromClass(arrayMClass), index, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
                return nil;
            }
        }else {
            return RSSWCallOriginal(index);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_nSArrayM_objectAtIndexedSubscript {
    Class arrayMClass = NSClassFromString(@"__NSArrayM");
    RSSwizzleInstanceMethod(arrayMClass, @selector(objectAtIndexedSubscript:), RSSWReturnType(id), RSSWArguments(NSUInteger idx), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self count] > idx) {
                return RSSWCallOriginal(idx);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[__NSArrayM objectAtIndexedSubscript:]: index %ld beyond bounds [0 .. %ld]", idx, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
                return nil;
            }
        }else {
            return RSSWCallOriginal(idx);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_nSArrayM_setObjectAtIndexedSubscript {
    Class arrayMClass = NSClassFromString(@"__NSArrayM");
    RSSwizzleInstanceMethod(arrayMClass, @selector(setObject:atIndexedSubscript:), RSSWReturnType(void), RSSWArguments(id obj, NSUInteger idx), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (obj && [self count] >= idx) {
                return RSSWCallOriginal(obj, idx);
            }else {
                if (!obj) {
                    [ZXRecord recordNoteErrorWithReason:@"-[__NSArrayM setObject:atIndexedSubscript:]: object cannot be nil" errorType:ZXCrashProtectionTypeContainer];
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[__NSArrayM setObject:atIndexedSubscript:]: index %ld beyond bounds [0 .. %ld]", idx, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
                }
            }
        }else {
            return RSSWCallOriginal(obj, idx);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_nSArrayM_removeObjectAtIndex {
    Class arrayMClass = NSClassFromString(@"__NSArrayM");
    RSSwizzleInstanceMethod(arrayMClass, @selector(removeObjectAtIndex:), RSSWReturnType(void), RSSWArguments(NSUInteger index), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self count] > index) {
                return RSSWCallOriginal(index);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[__NSArrayM removeObjectAtIndex:]: index %ld beyond bounds [0 .. %ld]", index, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
            }
        }else {
            return RSSWCallOriginal(index);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_nSArrrayM_insertObjectAtIndex {
    Class arrayMClass = NSClassFromString(@"__NSArrayM");
    RSSwizzleInstanceMethod(arrayMClass, @selector(insertObject:atIndex:), RSSWReturnType(void), RSSWArguments(id anObject, NSUInteger index), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (anObject && [self count] >= index) {
                return RSSWCallOriginal(anObject, index);
            }else {
                if (!anObject) {
                    [ZXRecord recordNoteErrorWithReason:@"-[__NSArrayM insertObject:atIndex:]: object cannot be nil" errorType:ZXCrashProtectionTypeContainer];
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[__NSArrayM setObject:atIndexedSubscript:]: index %ld beyond bounds [0 .. %ld]", index, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
                }
            }
        }else {
            return RSSWCallOriginal(anObject, index);
        }
    }), RSSwizzleModeAlways, nil);
}

@end
