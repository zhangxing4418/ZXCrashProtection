//
//  BaseStringSwizzleMethod.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/25.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseStringSwizzleMethod : NSObject

+ (void)zx_swizzle_initMethodForClass:(Class)class;
+ (void)zx_swizzle_operationMethodForClass:(Class)class;

@end

NS_ASSUME_NONNULL_END
