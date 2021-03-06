//
//  ZXCrashProtection.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ZXCrashProtectionType) {
    ZXCrashProtectionTypeUnrecognizedSelector = 1 << 1,
    ZXCrashProtectionTypeKVO = 1 << 2,
    ZXCrashProtectionTypeNotification = 1 << 3,
    ZXCrashProtectionTypeTimer = 1 << 4,
    ZXCrashProtectionTypeContainer = 1 << 5,
    ZXCrashProtectionTypeString = 1 << 6,
    ZXCrashProtectionTypeAll = (ZXCrashProtectionTypeUnrecognizedSelector | ZXCrashProtectionTypeKVO | ZXCrashProtectionTypeNotification | ZXCrashProtectionTypeTimer | ZXCrashProtectionTypeContainer | ZXCrashProtectionTypeString)
};

@protocol ZXCrashProtectionProtocol <NSObject>

- (void)recordErrorName:(NSString *)errorName reason:(NSString *)errorReason callStack:(NSArray *)callStack extraInfo:(NSDictionary *)extraInfo;

@end

@interface ZXCrashProtection : NSObject

+ (BOOL)isWorking;
+ (void)recordErrorDelegate:(id<ZXCrashProtectionProtocol>)delegate;
+ (void)startWithProtectionType:(ZXCrashProtectionType)type;
+ (void)start;
+ (void)stop;

@end

NS_ASSUME_NONNULL_END
