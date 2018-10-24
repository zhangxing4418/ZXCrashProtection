//
//  ZXRecord.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXCrashProtection.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXRecord : NSObject

+ (void)recordErrorDelegate:(id<ZXCrashProtectionProtocol>)delegate;

+ (void)recordNoteErrorWithReason:(NSString *)errorReason errorType:(ZXCrashProtectionType)errorType;

@end

NS_ASSUME_NONNULL_END
