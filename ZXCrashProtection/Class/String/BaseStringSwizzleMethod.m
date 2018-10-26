//
//  BaseStringSwizzleMethod.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/25.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "BaseStringSwizzleMethod.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle.h>

@implementation BaseStringSwizzleMethod

+ (void)zx_swizzle_initMethodForClass:(Class)class {
    [BaseStringSwizzleMethod __zx_swizzle_initWithStringForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_initWithUTF8StringForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_initWithFormatForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_initWithCStringEncodingForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_initWithCharactersLengthForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_initWithCoderForClass:class];
}

+ (void)zx_swizzle_operationMethodForClass:(Class)class {
    [BaseStringSwizzleMethod __zx_swizzle_characterAtIndexForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_substringFromIndexForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_substringToIndexForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_substringWithRangeForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_stringByReplacingOccurrencesOfStringWithStringOptionsRangeForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_stringByReplacingCharactersInRangeWithStringForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_stringByAppendingStringForClass:class];
    [BaseStringSwizzleMethod __zx_swizzle_stringByAppendingPathExtensionForClass:class];
}

#pragma mark - initMethod
+ (void)__zx_swizzle_initWithStringForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(initWithString:), RSSWReturnType(id), RSSWArguments(NSString *aString), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (aString) {
                return RSSWCallOriginal(aString);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ initWithString:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(aString);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_initWithUTF8StringForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(initWithUTF8String:), RSSWReturnType(id), RSSWArguments(const char *nullTerminatedCString), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (nullTerminatedCString) {
                return RSSWCallOriginal(nullTerminatedCString);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ initWithUTF8String:]: NULL cString", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(nullTerminatedCString);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_initWithFormatForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(initWithFormat:locale:arguments:), RSSWReturnType(id), RSSWArguments(NSString *format, id locale, va_list argList), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (format) {
                return RSSWCallOriginal(format, locale, argList);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ initWithFormat:locale:arguments:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(format, locale, argList);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_initWithCStringEncodingForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(initWithCString:encoding:), RSSWReturnType(id), RSSWArguments(const char *nullTerminatedCString, NSStringEncoding encoding), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (nullTerminatedCString) {
                return RSSWCallOriginal(nullTerminatedCString, encoding);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ initWithCString:encoding:]: nil cString", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(nullTerminatedCString, encoding);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_initWithCharactersLengthForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(initWithCharacters:length:), RSSWReturnType(id), RSSWArguments(const unichar *characters, NSUInteger length), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (characters) {
                return RSSWCallOriginal(characters, length);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ initWithCharacters:length:]: characters can not be nil", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(characters, length);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_initWithCoderForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(initWithCoder:), RSSWReturnType(id), RSSWArguments(NSCoder *coder), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (coder) {
                return RSSWCallOriginal(coder);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"%@ cannot decode class version 0", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(coder);
        }
    }), RSSwizzleModeAlways, nil);
}

#pragma mark - operationMethod
+ (void)__zx_swizzle_characterAtIndexForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(characterAtIndex:), RSSWReturnType(unichar), RSSWArguments(NSUInteger index), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self length] > index) {
                return RSSWCallOriginal(index);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ characterAtIndex:]: Index %ld out of bounds; string length %ld", NSStringFromClass(class), index, [self length]] errorType:ZXCrashProtectionTypeString];
                return 0;
            }
        }else {
            return RSSWCallOriginal(index);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_substringFromIndexForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(substringFromIndex:), RSSWReturnType(NSString *), RSSWArguments(NSUInteger from), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self length] >= from) {
                return RSSWCallOriginal(from);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ substringFromIndex:]: Index %ld out of bounds; string length %ld", NSStringFromClass(class), from, [self length]] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(from);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_substringToIndexForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(substringToIndex:), RSSWReturnType(NSString *), RSSWArguments(NSUInteger to), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ([self length] >= to) {
                return RSSWCallOriginal(to);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ substringToIndex:]: Index %ld out of bounds; string length %ld", NSStringFromClass(class), to, [self length]] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(to);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_substringWithRangeForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(substringWithRange:), RSSWReturnType(NSString *), RSSWArguments(NSRange range), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if ((NSInteger)range.location >= 0 && (NSInteger)range.length >= 0 && NSMaxRange(range) <= [self length]) {
                return RSSWCallOriginal(range);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ substringWithRange:]: Range %@ out of bounds; string length %ld", NSStringFromClass(class), NSStringFromRange(range), [self length]] errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(range);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_stringByReplacingOccurrencesOfStringWithStringOptionsRangeForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(stringByReplacingOccurrencesOfString:withString:options:range:), RSSWReturnType(NSString *), RSSWArguments(NSString *target, NSString *replacement, NSStringCompareOptions options, NSRange searchRange), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (target && replacement) {
                if ((NSInteger)searchRange.location >= 0 && (NSInteger)searchRange.length >= 0 && NSMaxRange(searchRange) <= [self length]) {
                    return RSSWCallOriginal(target, replacement, options, searchRange);
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ stringByReplacingOccurrencesOfString:withString:options:range:]: Range %@ out of bounds; string length %ld", NSStringFromClass(class), NSStringFromRange(searchRange), [self length]] errorType:ZXCrashProtectionTypeString];
                    return self;
                }
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ stringByReplacingOccurrencesOfString:withString:options:range:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return self;
            }
        }else {
            return RSSWCallOriginal(target, replacement, options, searchRange);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_stringByReplacingCharactersInRangeWithStringForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(stringByReplacingCharactersInRange:withString:), RSSWReturnType(NSString *), RSSWArguments(NSRange range, NSString *replacement), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (replacement) {
                if ((NSInteger)range.location >= 0 && (NSInteger)range.length >= 0 && NSMaxRange(range) <= [self length]) {
                    return RSSWCallOriginal(range, replacement);
                }else {
                    [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ stringByReplacingCharactersInRange:withString:]: Range %@ out of bounds; string length %ld", NSStringFromClass(class), NSStringFromRange(range), [self length]] errorType:ZXCrashProtectionTypeString];
                    return self;
                }
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ stringByReplacingCharactersInRange:withString:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return self;
            }
        }else {
            return RSSWCallOriginal(range, replacement);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_stringByAppendingStringForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(stringByAppendingString:), RSSWReturnType(NSString *), RSSWArguments(NSString *aString), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (aString) {
                return RSSWCallOriginal(aString);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ stringByAppendingString:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return self;
            }
        }else {
            return RSSWCallOriginal(aString);
        }
    }), RSSwizzleModeAlways, nil);
}

+ (void)__zx_swizzle_stringByAppendingPathExtensionForClass:(Class)class {
    RSSwizzleInstanceMethod(class, @selector(stringByAppendingPathExtension:), RSSWReturnType(NSString *), RSSWArguments(NSString *str), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (str) {
                return RSSWCallOriginal(str);
            }else {
                [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ stringByAppendingPathExtension:]: nil argument", NSStringFromClass(class)] errorType:ZXCrashProtectionTypeString];
                return self;
            }
        }else {
            return RSSWCallOriginal(str);
        }
    }), RSSwizzleModeAlways, nil);
}

@end
