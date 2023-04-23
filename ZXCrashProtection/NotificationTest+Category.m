//
//  NotificationTest+Category.m
//  ZXCrashProtection
//
//  Created by bug on 2018/11/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "NotificationTest+Category.h"

@implementation NotificationTest (Category)

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"test" object:nil];
}

- (void)test:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
}

@end
