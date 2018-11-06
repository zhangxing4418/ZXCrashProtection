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
@property (nonatomic, strong) UITextField *textField;
//@property (nonatomic, strong) UILabel *label;
//@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"close" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    self.btn.frame = CGRectMake(100, 300, 100, 50);
    [self.view addSubview:self.btn];
    
    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.frame = CGRectMake(150, 400, 100, 50);
    [self.view addSubview:self.textField];
    
    
//    [self.test addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionInitial context:nil];
    [self.btn addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionInitial context:nil];
//    [self.test addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionInitial context:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self.test selector:@selector(test:) name:@"test" object:nil];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.test selector:@selector(timeTest) userInfo:nil repeats:YES];
}



- (IBAction)close:(UIButton *)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:@"testxxxxx"];
    
    self.btn.backgroundColor = [UIColor redColor];
    
//    [self.btn removeObserver:[UIApplication sharedApplication].delegate forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self.label forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self forKeyPath:@"backgroundColor"];
//    [self.btn removeObserver:self forKeyPath:@"backgroundColor"];
//    [self.test removeObserver:self forKeyPath:@"backgroundColor"];
//    [self dismissViewControllerAnimated:YES completion:nil ];
    [self.textField endEditing:YES];
//    self.test = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change");
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self.test name:@"test" object:nil];
    
//    [self.test removeObserver:self forKeyPath:@"backgroundColor"];
    NSLog(@"KVOViewController dealloc");
}

@end
