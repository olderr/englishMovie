//
//  WIBWelcomeViewController.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBWelcomeViewController.h"
//主框架
#import "WIBFrameVC.h"

/**第一次启动程序、注销之后*/
@interface WIBWelcomeViewController ()<UIScrollViewDelegate>
{
    //登录页面
    UIView *_loginView;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;

    //下载
    AFHTTPRequestOperationManager *_manager;
}

@end

@implementation WIBWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createLoginView];

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    //禁止越界
    _scrollView.bounces = NO;
    //一页一页的跳
    _scrollView.pagingEnabled = YES;
    //隐藏水平线
    _scrollView.showsHorizontalScrollIndicator = NO;
    //代理
    _scrollView.delegate = self;
    NSArray *imagesName = @[@"wel_peiyin.jpg",@"wel_hudong.jpg",@"wel_fenxiang.jpg"];
    _scrollView.contentSize = CGSizeMake(kWIDTH * 4, kHEIGHT);
    for (int i = 0; i < 3; i++) {
        UIImageView *iv = kINIT_FRAME(UIImageView, kWIDTH * i, (kHEIGHT - 350 )/2.0 - 20, kWIDTH, 350);
        UIImage *image = [UIImage imageNamed:imagesName[i]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        iv.image = image;
        [_scrollView addSubview:iv];
    }
    _loginView.frame = CGRectMake(kWIDTH * 3, 0, kWIDTH, kHEIGHT);
    [_scrollView addSubview:_loginView];

    [self.view addSubview:_scrollView];

//创建pageControl
    _pageControl = kINIT_FRAME(UIPageControl, kWIDTH / 2 - 50, kHEIGHT - 20, 100, 20);
    _pageControl.numberOfPages = 4;
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:_pageControl];
}
- (void)createLoginView
{
    //login_regist quick_login
//最后一页
    _loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    _loginView.backgroundColor = [UIColor whiteColor];
    UIImageView *iv = kINIT_FRAME(UIImageView, 0, 0, kWIDTH, 503);
    iv.image = [UIImage imageNamed:@"login_regist"];
    iv.userInteractionEnabled = YES;
    iv.alpha = 0.1;
    [_loginView addSubview:iv];
//前景半透明样式
    UIView *fore = kINIT_FRAME(UIView, 0, 0, kWIDTH, kHEIGHT);
    fore.backgroundColor = [UIColor clearColor];
    fore.userInteractionEnabled = YES;


//立即体验
    UIButton *loginBtn = kINIT_FRAME(UIButton, (kWIDTH - 130)/2.0, (kHEIGHT - 120) / 2 , 130, 40);
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchDown];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"登录注册313立即登陆底板"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fore addSubview:loginBtn];
//是否阅读协议button
    //选择icon88@2x  选中icon88@2x
    UIButton *isReadBtn = kINIT_FRAME(UIButton , (kWIDTH - 130)/2.0 - 5 - 16, (kHEIGHT - 120) / 2 + 10 - 15 + 40, 44, 44);
    [isReadBtn setBackgroundImage:[UIImage imageNamed:@"选中icon88"] forState:UIControlStateNormal];
    [isReadBtn addTarget:self action:@selector(choiceIsRead:) forControlEvents:UIControlEventTouchDown];
    [isReadBtn setBackgroundImage:[UIImage imageNamed:@"选择icon88"] forState:UIControlStateSelected];
    [fore addSubview:isReadBtn];
//协议label
    UIButton *readBtn = kINIT_FRAME(UIButton , (kWIDTH - 130)/2.0 + 7, (kHEIGHT - 120) / 2 + 10 + 40, 120, 12);
    [readBtn addTarget:self action:@selector(readProtocol) forControlEvents:UIControlEventTouchDown];
    UILabel *label = kINIT_FRAME(UILabel, 0, 0, 120, 12);
    label.text = @"已阅读声明与使用协议";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    [readBtn addSubview:label];
    [fore addSubview:readBtn];

    [_loginView addSubview:fore];
    [_loginView bringSubviewToFront:fore];

//添加登录按钮
    UIImageView *loginImageView = kINIT_FRAME(UIImageView, 0, kHEIGHT - 120, kWIDTH, 120);
    loginImageView.userInteractionEnabled = YES;
    loginImageView.image = [UIImage imageNamed:@"quick_login"];
    NSArray *btnImageNames = @[@"登录注册313手机",@"微博登录注册313",@"qq登录注册313"];//55 * 55
    CGFloat x = (kWIDTH - (55 * 3)) / 4;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = kINIT_FRAME(UIButton , (x + 55)* i + x, 30, 55, 55);
        [btn setBackgroundImage:[UIImage imageNamed:btnImageNames[i]] forState:UIControlStateNormal];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(loginFromClick:) forControlEvents:UIControlEventTouchDown];
        [loginImageView addSubview:btn];
    }
    [_loginView addSubview:loginImageView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark scrollView 滚动协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / kWIDTH;
}
#pragma mark 点击立即体验
- (void)loginClick
{
    //判断是否存在用户信息
    [self getUidUtoken];

    //登录到主页面
    WIBFrameVC *frame = [[WIBFrameVC alloc]init];
    [self presentViewController:frame animated:YES completion:nil];
}
#pragma mark - 获取uid token
- (void)getUidUtoken
{
    NSString *url = [NSString stringWithFormat:kGET_USER_INFO,[[UIDevice currentDevice].identifierForVendor UUIDString]];

    _manager = [[AFHTTPRequestOperationManager alloc]init];
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:dict[@"uid"] forKey:kUID];
        [user setObject:dict[@"auth_token"] forKey:kTOKEN];
        [user synchronize];
        NSLog(@"%@",[user objectForKey:kTOKEN]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark 是否阅读了协议
- (void)choiceIsRead:(UIButton *)btn
{
    [btn setSelected:!btn.isSelected];
    NSLog(@"selected");
}
#pragma mark 阅读protocol
- (void)readProtocol
{
    NSLog(@"protocol");
}
#pragma mark 选择从何登录
- (void)loginFromClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 10:
        {
            //手机

        }
            break;
        case 11:
        {
            //微博

        }
            break;
        case 12:
        {
            //QQ
        }
            break;
        default:
            break;
    }
}

@end
