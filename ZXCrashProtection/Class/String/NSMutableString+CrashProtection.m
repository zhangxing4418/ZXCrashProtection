//
//  NSMutableString+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/25.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSMutableString+CrashProtection.h"
#import "BaseStringSwizzleMethod.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle.h>

@implementation NSMutableString(CrashProtection)

+ (void)launchNSMutableStringCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [BaseStringSwizzleMethod zx_swizzle_initMethodForClass:NSClassFromString(@"NSPlaceholderMutableString")];
        [BaseStringSwizzleMethod zx_swizzle_operationMethodForClass:NSClassFromString(@"__NSCFString")];
        [NSMutableString zx_swizzle_replaceCharactersInRangeWithString];
        [NSMutableString zx_swizzle_replaceOccurrencesOfStringWithStringOptionsRange];
        [NSMutableString zx_swizzle_insertStringAtIndex];
        [NSMutableString zx_swizzle_deleteCharactersInRange];
        [NSMutableString zx_swizzle_appendString];
    });
}

+ (void)zx_swizzle_replaceCharactersInRangeWithString {
    Class class = NSClassFromString(@"__NSCFString");
    RSSwizzleInstanceMethod(class, @selector(replaceCharactersInRange:withString:), RSSWReturnType(void), RSSWArguments(NSRange range, NSString *aString), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (aString) {
                if ((NSInteger)range.location >= 0 && (NSInteger)range.length >= 0 && NSMaxRange(range) <= [self length]) {
                    RSSWCallOriginal(range, aString);
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withString:]: Range %@ out of bounds; string length %ld", NSStringFromClass(class), NSStringFromRange(range), [self length]] errorType:ZXCrashProtectionTypeString];
                }
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withString:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
            }
        }else {
            RSSWCallOriginal(range, aString);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_replaceOccurrencesOfStringWithStringOptionsRange {
    Class class = NSClassFromString(@"__NSCFString");
    RSSwizzleInstanceMethod(class, @selector(replaceOccurrencesOfString:withString:options:range:), RSSWReturnType(NSUInteger), RSSWArguments(NSString *target, NSString *replacement, NSStringCompareOptions options, NSRange searchRange), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (target && replacement) {
                if ((NSInteger)searchRange.location >= 0 && (NSInteger)searchRange.length >= 0 && NSMaxRange(searchRange) <= [self length]) {
                    return RSSWCallOriginal(target, replacement, options, searchRange);
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ replaceOccurrencesOfString:withString:options:range:]: Range %@ out of bounds; string length %ld", NSStringFromClass(class), NSStringFromRange(searchRange), [self length]] errorType:ZXCrashProtectionTypeString];
                    return 0;
                }
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ replaceOccurrencesOfString:withString:options:range:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return 0;
            }
        }else {
            return RSSWCallOriginal(target, replacement, options, searchRange);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_insertStringAtIndex {
    Class class = NSClassFromString(@"__NSCFString");
    RSSwizzleInstanceMethod(class, @selector(insertString:atIndex:), RSSWReturnType(void), RSSWArguments(NSString *aString, NSUInteger loc), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (aString) {
                if ([self length] >= loc) {
                    RSSWCallOriginal(aString, loc);
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ insertString:atIndex:]: Index %ld out of bounds", NSStringFromClass(class), loc] errorType:ZXCrashProtectionTypeString];
                }
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ insertString:atIndex:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
            }
        }else {
            RSSWCallOriginal(aString, loc);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_deleteCharactersInRange {
    Class class = NSClassFromString(@"__NSCFString");
    RSSwizzleInstanceMethod(class, @selector(deleteCharactersInRange:), RSSWReturnType(void), RSSWArguments(NSRange range), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ((NSInteger)range.location >= 0 && (NSInteger)range.length >= 0 && NSMaxRange(range) <= [self length]) {
                RSSWCallOriginal(range);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ deleteCharactersInRange:]: Range %@ out of bounds", NSStringFromClass(class), NSStringFromRange(range)] errorType:ZXCrashProtectionTypeString];
            }
        }else {
            RSSWCallOriginal(range);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)zx_swizzle_appendString {
    Class class = NSClassFromString(@"__NSCFString");
    RSSwizzleInstanceMethod(class, @selector(appendString:), RSSWReturnType(void), RSSWArguments(NSString *aString), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (aString) {
                RSSWCallOriginal(aString);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ appendString:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
            }
        }else {
            RSSWCallOriginal(aString);
        }
    }), RSSwizzleModeAlways, nil);
}



@end
