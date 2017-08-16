//
//  TestViewController.m
//  Empty
//
//  Created by xiaoqi on 2017/8/15.
//  Copyright © 2017年 loveseven. All rights reserved.
//

#import "TestViewController.h"

#import "YCGifView.h"
#import "YCGifImageView.h"

@interface TestViewController ()

@property (nonatomic, strong) YCGifView *gifView;
@property (nonatomic, strong) YCGifImageView *gifImageView;

@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UIButton *internetBtn;

@end

@implementation TestViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configerGifLoading];
    
}

#pragma mark -- Gif load加载

- (void)configerGifLoading {
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(200);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    self.locationBtn.backgroundColor = [UIColor redColor];
    [self.locationBtn setTitle:@"本地加载gif" forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(clickLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.internetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.internetBtn];
    [self.internetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.locationBtn.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    self.internetBtn.backgroundColor = [UIColor cyanColor];
    [self.internetBtn setTitle:@"网络加载gif" forState:UIControlStateNormal];
    [self.internetBtn addTarget:self action:@selector(clickInternetBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 监听一个按钮的点击事件：
//    [[self.locationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x ){
//        NSLog(@"点击了按钮");
//    }];
    
    
}

- (void)clickLocationBtn:(UIButton *)sender {
    
    [self removeGif];
    
    //方法1:适用于帧数少的gif动画
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading" ofType:@"gif"]];
    
    _gifView = [[YCGifView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, CGRectGetMaxY(self.internetBtn.frame)+20, 100, 60) data:localData];
    [self.view addSubview:_gifView];
    
    
    [_gifView startGif];
    
    //方法2:适用于帧数多的gif动画
//    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Loading" ofType:@"gif"]];
//    _gifImageView = [[LLGifImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 80) data:localData];
//    [self.view addSubview:_gifImageView];
//    [_gifImageView startGif];

    
}

- (void)clickInternetBtn:(UIButton *)sender {
    
    [self removeGif];
    //此处使用异步加载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pic19.nipic.com/20120222/8072717_124734762000_2.gif"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (urlData) {
                _gifView = [[YCGifView alloc] initWithFrame:CGRectMake(100, 300, 200, 80) data:urlData];
                [self.view addSubview:_gifView];
                [_gifView startGif];
            }
            else {
                NSLog(@"请允许应用访问网络");
            }
        });
    });
    
}


- (void)removeGif {
   
    if (_gifView) {
        [_gifView removeFromSuperview];
        _gifView = nil;
    }else if (_gifImageView) {
        [_gifImageView removeFromSuperview];
        _gifImageView = nil;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
