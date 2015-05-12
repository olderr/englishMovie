//
//  WIBRoootCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBRoootCtr.h"
#import "WIBTabbarViewController.h"

@interface WIBRoootCtr ()

@end

@implementation WIBRoootCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航条和tabber的隐藏
- (void)viewWillAppear:(BOOL)animated
{
    [(WIBTabbarViewController *)self.tabBarController setHiddenTabbar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [(WIBTabbarViewController *)self.tabBarController setShowTabbar];
}

#pragma mark - 定制Nav
- (void)customNav
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    title.text = self.title;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;

    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftView.userInteractionEnabled = YES;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(-22, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];

    [leftView addSubview:leftBtn];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
