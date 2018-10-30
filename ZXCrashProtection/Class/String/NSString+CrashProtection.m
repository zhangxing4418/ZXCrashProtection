//
//  NSString+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/25.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSString+CrashProtection.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import "BaseStringSwizzleMethod.h"
#import <RSSwizzle.h>

@implementation NSString(CrashProtection)

+ (void)launchNSStringCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSString zx_swizzle_stringWithCharactersLength];
        [NSString zx_swizzle_stringWithUTF8String];
        [NSString zx_swizzle_stringWithCStringEncoding];
        [BaseStringSwizzleMethod zx_swizzle_initMethodForClass:NSClassFromString(@"NSPlaceholderString")];
        [BaseStringSwizzleMethod zx_swizzle_operationMethodForClass:NSClassFromString(@"__NSCFConstantString")];
        if (@available(iOS 9.0, *)) {
            [BaseStringSwizzleMethod zx_swizzle_operationMethodForClass:NSClassFromString(@"NSTaggedPointerString")];
        }else {
            [BaseStringSwizzleMethod zx_swizzle_operationMethodForClass:NSClassFromString(@"__NSCFString")];
        }
    });
}

+ (void)zx_swizzle_stringWithCharactersLength {
    RSSwizzleClassMethod([NSString class], @selector(stringWithCharacters:length:), RSSWReturnType(id), RSSWArguments(const unichar *characters, NSUInteger length), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (characters) {
                return RSSWCallOriginal(characters, length);
            }else {
                [ZXRecord recordNoteErrorWithReason:@"+[NSString stringWithCharacters:length:]: characters can not be nil" errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(characters, length);
        }
    }));
}

+ (void)zx_swizzle_stringWithUTF8String {
    RSSwizzleClassMethod([NSString class], @selector(stringWithUTF8String:), RSSWReturnType(id), RSSWArguments(const char *nullTerminatedCString), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (nullTerminatedCString) {
                return RSSWCallOriginal(nullTerminatedCString);
            }else {
                [ZXRecord recordNoteErrorWithReason:@"+[NSString stringWithUTF8String:]: NULL cString" errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(nullTerminatedCString);
        }
    }));
}

+ (void)zx_swizzle_stringWithCStringEncoding {
    RSSwizzleClassMethod([NSString class], @selector(stringWithCString:encoding:), RSSWReturnType(id), RSSWArguments(const char *cString, NSStringEncoding enc), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (cString) {
                return RSSWCallOriginal(cString, enc);
            }else {
                [ZXRecord recordNoteErrorWithReason:@"+[NSString stringWithCString:encoding:]: NULL cString" errorType:ZXCrashProtectionTypeString];
                return nil;
            }
        }else {
            return RSSWCallOriginal(cString, enc);
        }
    }));
}

@end
