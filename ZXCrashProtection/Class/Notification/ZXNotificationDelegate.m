//
//  ZXNotificationDelegate.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/30.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ZXNotificationDelegate.h"
#import "ZXRecord.h"

@interface ZXNotificationDelegate () {
    __unsafe_unretained id _observer;
}

@end

@implementation ZXNotificationDelegate

- (instancetype)initWithObserver:(id)observer {
    if (self = [super init]) {
        _observer = observer;
    }
    return self;
}

- (void)dealloc {
    if (_observer && self.needRemove) {
        [[NSNotificationCenter defaultCenter] removeObserver:_observer];
        [ZXRecord recordNoteErrorWithReason:[NSString stringWithFormat:@"Notification removeObserver: %@", _observer] errorType:ZXCrashProtectionTypeNotification];
    }
}

@end
