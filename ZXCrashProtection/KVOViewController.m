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
//@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NotificationTest *test;
//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.test = [[NotificationTest alloc] init];
    [self.test addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionInitial context:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self.test selector:@selector(test:) name:@"test" object:nil];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.test selector:@selector(timeTest) userInfo:nil repeats:YES];
}



- (IBAction)close:(UIButton *)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:@"testxxxxx"];
    
//    self.btn.backgroundColor = [UIColor redColor];
    
//    [self.btn removeObserver:[UIApplication sharedApplication].delegate forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self.label forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self forKeyPath:@"backgroundColor"];
//    [self.test removeObserver:self forKeyPath:@"backgroundColor"];
    [self dismissViewControllerAnimated:YES completion:nil ];
//    self.test = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self.test name:@"test" object:nil];
    [self.test removeObserver:self forKeyPath:@"backgroundColor"];
    NSLog(@"KVOViewController dealloc");
}

@end
