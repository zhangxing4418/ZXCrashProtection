//
//  ViewController.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/23.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "ViewController.h"
#import "KVOViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)postNotification:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:@"testxxxxx"];
}

@end
