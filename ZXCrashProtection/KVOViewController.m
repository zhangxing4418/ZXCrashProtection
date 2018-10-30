//
//  KVOViewController.m
//  ZXCrashProtection
//
//  Created by bug on 2018/10/26.
//  Copyright © 2018 CRM. All rights reserved.
//

#import "KVOViewController.h"

@interface KVOViewController ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.label = [[UILabel alloc] init];
    [self.btn addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
//    [self.btn addObserver:self forKeyPath:@"titleLabel" options:NSKeyValueObservingOptionNew context:nil];
//    [self.btn addObserver:self.label forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
//    [self.btn addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
}

- (IBAction)close:(UIButton *)sender {
//    self.btn.backgroundColor = [UIColor redColor];
    
//    [self.btn removeObserver:[UIApplication sharedApplication].delegate forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self.label forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self forKeyPath:@"backgroundColor"];
    
    [self dismissViewControllerAnimated:YES completion:nil ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", keyPath);
}

@end
