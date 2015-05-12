//
//  WIBMineCtr.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBMineCtr : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *avater;

@property (weak, nonatomic) IBOutlet UIImageView *sex;

@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (weak, nonatomic) IBOutlet UIButton *binding;

@property (weak, nonatomic) IBOutlet UIButton *fans;

@property (weak, nonatomic) IBOutlet UIButton *follow;

@property (weak, nonatomic) IBOutlet UIButton *visitor;


@property (weak, nonatomic) IBOutlet UIButton *photo;

@property (weak, nonatomic) IBOutlet UILabel *fansNum;

@property (weak, nonatomic) IBOutlet UILabel *followNum;

@property (weak, nonatomic) IBOutlet UILabel *visterNum;

@property (weak, nonatomic) IBOutlet UILabel *photoNum;
//我的配音
@property (weak, nonatomic) IBOutlet UILabel *wantToBtn;

//button点击时间
- (IBAction)btnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *wantToNum;

//视频缓存
@property (weak, nonatomic) IBOutlet UIButton *cache;
@property (weak, nonatomic) IBOutlet UILabel *cacheNum;
//视频收藏
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *btn2Num;
//生词本
@property (weak, nonatomic) IBOutlet UIButton *wordBtn;
@property (weak, nonatomic) IBOutlet UILabel *wordNum;
//上传视频
@property (weak, nonatomic) IBOutlet UIButton *upMovie;
@property (weak, nonatomic) IBOutlet UILabel *upNum;
//告诉朋友剖
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UILabel *btn5Num;

//设置
- (IBAction)settingBtnClick:(id)sender;
- (IBAction)letterClick:(id)sender;
- (IBAction)avatarClick:(id)sender;

- (IBAction)binding:(id)sender;
- (IBAction)fansClick:(UIButton *)sender;


@end
