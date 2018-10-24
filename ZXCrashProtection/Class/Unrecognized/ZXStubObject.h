//
//  ZXStubObject.h
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXStubObject : NSObject

+ (ZXStubObject *)shareInstance;
- (BOOL)addFunc:(SEL)sel;

@end

NS_ASSUME_NONNULL_END
