//
//  NSArray+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/24.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSArray+CrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation NSArray(CrashProtection)

+ (void)launchNSArrayCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSArray zx_swizzle_nSArray_arrayWithObjectsCounts];
        [NSArray zx_swizzle_nSArray_objectsAtIndexes];
        [NSArray zx_swizzle_nSarrayI_objectAtIndex];
        [NSArray zx_swizzle_nSSingleObjectArrayI_objectAtIndex];
        [NSArray zx_swizzle_nSArray0_objectAtIndex];
        [NSArray zx_swizzle_nSarrayI_objectAtIndexedSubscript];
    });
}

+ (void)zx_swizzle_nSArray_arrayWithObjectsCounts {
    RSSwizzleClassMethod([self class], @selector(arrayWithObjects:count:), RSSWReturnType(id), RSSWArguments(const id *objects, NSUInteger cnt), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            id instance = nil;
            @try {
                instance = RSSWCallOriginal(objects, cnt);
            } @catch (NSException *exception) {
                [ZXRecord recordNoteErrorWithReason:exception.reason errorType:ZXCrashProtectionTypeContainer];
                NSInteger newObjsIndex = 0;
                id  _Nonnull __unsafe_unretained newObjects[cnt];
                for (int i = 0; i < cnt; i++) {
                    if (objects[i] != nil) {
                        newObjects[newObjsIndex] = objects[i];
                        newObjsIndex ++;
                    }
                }
                instance = RSSWCallOriginal(newObjects, newObjsIndex);
            } @finally {
                return instance;
            }
        }
        return RSSWCallOriginal(objects, cnt);
    }));
}

+ (void)zx_swizzle_nSArray_objectsAtIndexes {
    Class __NSArray = NSClassFromString(@"NSArray");
    RSSwizzleInstanceMethod(__NSArray, @selector(objectsAtIndexes:), RSSWReturnType(NSArray *), RSSWArguments(NSIndexSet *indexes), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self count] > indexes.lastIndex || indexes.count == 0) {
                return RSSWCallOriginal(indexes);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[NSArray objectsAtIndexes:]: index %ld in index set beyond bounds [0 .. %ld]", indexes.lastIndex, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
                return @[];
            }
        }else {
            return RSSWCallOriginal(indexes);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_nSarrayI_objectAtIndex {
    Class __NSArrayI = NSClassFromString(@"__NSArrayI");
    [NSArray __zx_swizzle_objectAtIndex_forClass:__NSArrayI];
}

+ (void)zx_swizzle_nSSingleObjectArrayI_objectAtIndex {
    Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
    [NSArray __zx_swizzle_objectAtIndex_forClass:__NSSingleObjectArrayI];
}

+ (void)zx_swizzle_nSArray0_objectAtIndex {
    Class __NSArray0 = NSClassFromString(@"__NSArray0");
    [NSArray __zx_swizzle_objectAtIndex_forClass:__NSArray0];
}

+ (void)zx_swizzle_nSarrayI_objectAtIndexedSubscript {
    Class __NSArrayI = NSClassFromString(@"__NSArrayI");
    RSSwizzleInstanceMethod(__NSArrayI, @selector(objectAtIndexedSubscript:), RSSWReturnType(id), RSSWArguments(NSUInteger idx), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self count] > idx) {
                return RSSWCallOriginal(idx);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[__NSArrayI objectAtIndexedSubscript:]: index %ld in index set beyond bounds [0 .. %ld]", idx, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
                return nil;
            }
        }else {
            return RSSWCallOriginal(idx);
        }
    }), RSSwizzleModeAlways, nil);
}

#pragma mark Private
+ (void)__zx_swizzle_objectAtIndex_forClass:(Class) class {
    if (class) {
        RSSwizzleInstanceMethod(class, @selector(objectAtIndex:), RSSWReturnType(id), RSSWArguments(NSUInteger index), RSSWReplacement({
            if ([ZXCrashProtection isWorking]) {
                if ([self count] > index) {
                    return RSSWCallOriginal(index);
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ objectAtIndex:]: index %ld in index set beyond bounds [0 .. %ld]", NSStringFromClass(class), index, [self count] - 1] errorType:ZXCrashProtectionTypeContainer];
                    return nil;
                }
            }else {
                return RSSWCallOriginal(index);
            }
        }), RSSwizzleModeAlways, nil);
    }
}

@end
