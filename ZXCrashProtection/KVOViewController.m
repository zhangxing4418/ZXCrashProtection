//
//  KVOViewController.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/26.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "KVOViewController.h"
#import "NotificationTest.h"

@interface KVOViewController ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NotificationTest *test;

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.test = [[NotificationTest alloc] init];
    [self.btn addObserver:self.test forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)test:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
}

- (IBAction)close:(UIButton *)sender {
//    [[NSNotificationCenter defaultCenter] removeObserver:self.test name:@"test" object:nil];
    
//    self.btn.backgroundColor = [UIColor redColor];
    
//    [self.btn removeObserver:[UIApplication sharedApplication].delegate forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self.label forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self forKeyPath:@"backgroundColor"];
    
    [self dismissViewControllerAnimated:YES completion:nil ];
}

@end
