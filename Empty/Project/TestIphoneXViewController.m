//
//  TestIphoneXViewController.m
//  Empty
//
//  Created by 贻成  王 on 2019/5/16.
//  Copyright © 2019 loveseven. All rights reserved.
//

#import "TestIphoneXViewController.h"

@interface TestIphoneXViewController ()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation TestIphoneXViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self interfaceOrientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backgroundView];
    CGFloat min_x = 0.0;
    CGFloat min_y = safeAreaNavBarHeight;
    CGFloat min_w = self.view.bounds.size.width;
    CGFloat min_h = self.view.bounds.size.height - min_y - safeAreaHeight;
    self.backgroundView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self interfaceOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark -
#pragma mark -- Private Functions

#pragma mark - 设置状态栏显示

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 强制横屏
/*
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}
*/

#pragma mark -- Lazy load

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor redColor];
    }
    return _backgroundView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
