//
//  NotificationTest.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/30.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NotificationTest.h"
#import "NotificationTest+Category.h"

@implementation NotificationTest

- (instancetype)init {
    if (self = [super init]) {
        [self addNotification];
    }
    return self;
}

//- (void)timeTest {
//    static int count = 0;
//    count++;
//    NSLog(@"Timer: %d", count);
//}
//
//- (void)test:(NSNotification *)notification {
//    NSLog(@"%@", notification.object);
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc NotificationTest");
}

@end
