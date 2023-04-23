//
//  ViewController.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ViewController.h"
#import "KVOViewController.h"
#import "NotificationTest.h"

@interface ViewController ()

//@property (nonatomic, strong) NotificationTest *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.test = [[NotificationTest alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)postNotification:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:@"testxxxxx"];
}

- (IBAction)push:(id)sender {
    KVOViewController *viewController = [[KVOViewController alloc] init];
//    viewController.test = self.test;
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
