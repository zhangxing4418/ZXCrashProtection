//
//  NSTimer+CrashProtection.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/31.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NSTimer+CrashProtection.h"
#import "ZXCrashProtection.h"
#import "ZXRecord.h"
#import <RSSwizzle.h>

@interface StubTarget : NSObject

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL aSelector;

@end

@implementation StubTarget

- (void)fireProxyTimer:(id)userInfo {
    if (self.target) {
        if ([self.target respondsToSelector:self.aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.aSelector withObject:userInfo];
#pragma clang diagnostic pop
        }
    }else {
        if (self.timer) {
            [self.timer invalidate];
            [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"-[%@ invalidate]: selector: %@", self.timer, NSStringFromSelector(self.aSelector)] errorType:ZXCrashProtectionTypeTimer];
        }
    }
}

@end

@implementation NSTimer(CrashProtection)

+ (void)launchNSTimerCrashProtection {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSTimer zx_swizzle_scheduledTimerWithTimeIntervalTargetSelectorUserInfoRepeats];
    });
}

+ (void)zx_swizzle_scheduledTimerWithTimeIntervalTargetSelectorUserInfoRepeats {
    RSSwizzleClassMethod([NSTimer class], @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), RSSWReturnType(NSTimer *), RSSWArguments(NSTimeInterval ti, id aTarget, SEL aSelector, id userInfo, BOOL yesOrNo), RSSWReplacement({
        if ([ZXCrashProtection isWorking]) {
            if (yesOrNo) {
                StubTarget *stubTarget = [[StubTarget alloc] init];
                stubTarget.target = aTarget;
                stubTarget.aSelector = aSelector;
                NSTimer *timer = RSSWCallOriginal(ti, stubTarget, @selector(fireProxyTimer:), userInfo, yesOrNo);
                stubTarget.timer = timer;
                return timer;
            }
        }
        return RSSWCallOriginal(ti, aTarget, aSelector, userInfo, yesOrNo);
    }));
}

@end
