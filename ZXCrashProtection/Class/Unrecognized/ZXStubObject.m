//
//  ZXStubObject.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ZXStubObject.h"
#import <objc/runtime.h>

int smartFunction(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunction, funcTypeEncoding);
}

static BOOL __firstTime;

@implementation ZXStubObject

+ (ZXStubObject *)shareInstance {
    __firstTime = YES;
    static ZXStubObject *singleton;
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [ZXStubObject new];
        });
    }
    return singleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!__firstTime) {
        return [ZXStubObject shareInstance];
    }
    return [super allocWithZone:zone];
}

+ (instancetype)new {
    if (!__firstTime) {
        return [ZXStubObject shareInstance];
    }
    return [super new];
}

- (BOOL)addFunc:(SEL)sel {
    return __addMethod([ZXStubObject class], sel);
}

@end
