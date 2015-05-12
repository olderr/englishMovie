//
//  WIBFrameVC.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBFrameVC.h"
#import "WIBNavViewController.h"
//主页
#import "WIBMainViewController.h"
//ishow
#import "WIBIShowViewController.h"
//我
#import "WIBMineCtr.h"

@interface WIBFrameVC ()

@end

@implementation WIBFrameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WIBMainViewController *main = [[WIBMainViewController alloc]init];
    WIBNavViewController *nav1 = [[WIBNavViewController alloc]initWithRootViewController:main];


    WIBIShowViewController *main2 = [[WIBIShowViewController alloc]init];
    WIBNavViewController *nav2 = [[WIBNavViewController alloc]initWithRootViewController:main2];


    WIBMineCtr *main3 = [[WIBMineCtr alloc]init];
    WIBNavViewController *nav3 = [[WIBNavViewController alloc]initWithRootViewController:main3];

    self.viewControllers = @[nav1,nav2,nav3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
