//
//  WIBTabbarViewController.m
//  QLV
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBTabbarViewController.h"

//btn 的大小
#define BUTTON_H 50
#define BUTTON_W 106

@interface WIBTabbarViewController ()
{
    UIView *_barBackView;

    NSArray *btnImageNor;
    NSArray *btnImageSel;
}

@end

@implementation WIBTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏掉原始tabbar
    self.tabBar.hidden = YES;
    //定制！
    [self customTabbar];
}
#pragma mark 定制
- (void)customTabbar
{
    btnImageNor = @[@"kecheng_nor",@"ishow_nor",@"wo_nor"];
    btnImageSel = @[@"kecheng_pre",@"ishow_pre",@"wo_pre"];

    _barBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT - 49, kWIDTH, 49)];
    _barBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]];
    _barBackView.userInteractionEnabled = YES;

    //创建button

    //每个btn之间的距离
    CGFloat btnW = (kWIDTH - BUTTON_W * btnImageNor.count)/(btnImageNor.count + 1);

    for (int i = 0; i < btnImageNor.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnW + (btnW + BUTTON_W) * i, 0, BUTTON_W, 49)];

        [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:btnImageNor[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:btnImageSel[i]] forState:UIControlStateSelected];
        if (i == 0) {
            [btn setSelected:YES];
        }
        btn.tag = 20 + i;
        [_barBackView addSubview:btn];
    }

    [self.view addSubview:_barBackView];
}
- (void)btnSelect:(UIButton *)btn
{
    self.selectedIndex = btn.tag - 20;
    [btn setSelected:YES];
    for (int i = 0; i < 5; i++) {
        UIButton *iv = (UIButton *)[self.view viewWithTag:i + 20];
        if (i == btn.tag - 20) {
            continue;
        }else {
            [iv setSelected:NO];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)selectViewController:(NSInteger)i
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:20 + i];
    [self btnSelect:btn];
}
- (void)setShowTabbar
{
    _barBackView.frame = CGRectMake(0, kHEIGHT - 49, kWIDTH, 49);
}

- (void)setHiddenTabbar
{
    _barBackView.frame = CGRectMake(0, kHEIGHT, kWIDTH, 49);
}

@end







