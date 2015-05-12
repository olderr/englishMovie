//
//  WIBMineCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBMineCtr.h"
#import "WIBRoootCtr.h"

#import "WIBUserInfo.h"
#import "UIButton+WebCache.h"
//点击头像
#import "WIBEditUserInfoCtr.h"
//点击sex
#import "WIBSetSexCtr.h"
//点击视频收藏
#import "WIBCollectCtr.h"
//点击视频缓存
#import "WIBMoiveDownCtr.h"

@interface WIBMineCtr ()
{
    AFHTTPRequestOperationManager *_requsetManager;
}
@property (nonatomic , strong) WIBUserInfo *userInfo;

@end

@implementation WIBMineCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //将头像转换成圆角
    self.avater.layer.cornerRadius = self.avater.frame.size.height / 2.0;
    self.avater.layer.masksToBounds = YES;
}

#pragma mark - 导航条的隐藏与出现
- (void)viewWillAppear:(BOOL)animated
{
    //数据请求
    [self requestUserInfo];
    
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
#pragma mark - 数据请求
- (void)requestUserInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:kUSER_BASE_INFO , [user objectForKey:kUID] , [user objectForKey:kUID] , [user objectForKey:kTOKEN]];
    if (_requsetManager == nil) {
        _requsetManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    [_requsetManager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.userInfo == nil) {
            self.userInfo = [[WIBUserInfo alloc]init];
        }
        [self.userInfo setValuesForKeysWithDictionary:responseObject[@"data"]];
        [self refreshInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(UIButton *)sender {

    switch (sender.tag - 100) {
        case 1:
        {
            WIBMoiveDownCtr *collectCtr = [[WIBMoiveDownCtr alloc]init];
            [self.navigationController pushViewController:collectCtr animated:YES];
            return;
        }
            break;
        case 2:
        {
            WIBCollectCtr *collectCtr = [[WIBCollectCtr alloc]init];
            [self.navigationController pushViewController:collectCtr animated:YES];
            return;
        }
            break;

        default:
            break;
    }
    NSArray *btnNames = @[@"我的配音",@"视频缓存",@"视频收藏",@"生词本",@"我要推荐",@"告诉朋友"];
    WIBRoootCtr *ctr = [[WIBRoootCtr alloc]init];
    ctr.title = btnNames[sender.tag - 100];
    [self.navigationController pushViewController:ctr animated:YES];
}
- (IBAction)settingBtnClick:(id)sender {
}

- (IBAction)letterClick:(id)sender {
}

//点击头像
- (IBAction)avatarClick:(id)sender {
    WIBEditUserInfoCtr *editUserInfo = [[WIBEditUserInfoCtr alloc]init];
    editUserInfo.userInfo = self.userInfo;
    [self.navigationController pushViewController:editUserInfo animated:YES];
}

- (IBAction)binding:(id)sender {
}

- (IBAction)fansClick:(UIButton *)sender {
}

#pragma mark - 刷新
- (void)refreshInfo
{
    //头像
    [self.avater sd_setBackgroundImageWithURL:[NSURL URLWithString:self.userInfo.avatar] forState:UIControlStateNormal];
    //性别
    if ([self.userInfo.sex isEqualToString:@"1"]) {
        self.sex.image = [UIImage imageNamed:@"男.png"];
    }else {
        self.sex.image = [UIImage imageNamed:@"女.png"];
    }
    //昵称
    self.nickname.text = self.userInfo.nickname;
    //粉丝
    self.fansNum.text = self.userInfo.fans;
    //关注
    self.followNum.text = self.userInfo.follows;
    //访客
    self.visterNum.text = self.userInfo.views;
    //相册
    self.photoNum.text = self.userInfo.photos;
    //我的配音
    self.wantToNum.text = self.userInfo.shows;
    //视频缓存
#warning 视频缓存个数
    //视频收藏
    self.btn2Num.text = self.userInfo.collects;
    //生词本
    self.wordNum.text = self.userInfo.words;
    //
}

@end
