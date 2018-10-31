//
//  NotificationTest.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/30.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NotificationTest.h"

@implementation NotificationTest

- (void)timeTest {
    static int count = 0;
    count++;
    NSLog(@"Timer: %d", count);
}

- (void)test:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

@end
