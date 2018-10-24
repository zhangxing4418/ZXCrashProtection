//
//  ZXRecord.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ZXRecord.h"

#define ZXCrashProtectionSeparator         @"======================================================================="
#define ZXCrashProtectionSeparatorWithFlag @"========================ZXCrashProtection Log=========================="

static id<ZXCrashProtectionProtocol>__delegate;

@implementation ZXRecord

+ (void)recordErrorDelegate:(id<ZXCrashProtectionProtocol>)delegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __delegate = delegate;
    });
}

+ (NSString *)errorNameWithErrorType:(ZXCrashProtectionType)errorType {
    switch (errorType) {
        case ZXCrashProtectionTypeUnrecognizedSelector:
            return @"ZXCrashProtectionTypeUnrecognizedSelector";
            
        case ZXCrashProtectionTypeKVO:
            return @"ZXCrashProtectionTypeKVO";
            
        case ZXCrashProtectionTypeTimer:
            return @"ZXCrashProtectionTypeTimer";
            
        case ZXCrashProtectionTypeNotification:
            return @"ZXCrashProtectionTypeNotification";
            
        case ZXCrashProtectionTypeContainer:
            return @"ZXCrashProtectionTypeContainer";
            
        case ZXCrashProtectionTypeString:
            return @"ZXCrashProtectionTypeString";
            
        default:
            return @"";
    }
}

+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                    
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}

+ (void)recordNoteErrorWithReason:(NSString *)errorReason errorType:(ZXCrashProtectionType)errorType {
    NSString *errorName = [ZXRecord errorNameWithErrorType:errorType];
    //堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [ZXRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    
    NSString *errorPlace = [NSString stringWithFormat:@"%@", mainCallStackSymbolMsg];
    
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@", ZXCrashProtectionSeparatorWithFlag, errorName, errorReason, errorPlace];
    
    logErrorMessage = [NSString stringWithFormat:@"%@\n\n%@\n\n", logErrorMessage, ZXCrashProtectionSeparator];
    NSLog(@"%@", logErrorMessage);
    
    [__delegate recordErrorName:errorName reason:errorReason callStack:callStackSymbolsArr extraInfo:@{@"errorPlace" : errorPlace ? errorPlace : @""}];
}

@end
