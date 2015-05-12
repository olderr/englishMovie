//
//  WIBCreateMovieInfoTableViewCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBCreateMovieInfoTableViewCell.h"
#import "WIBMainModel.h"
#import "UIButton+WebCache.h"


@implementation WIBCreateMovieInfoTableViewCell
{
    NSArray *_btnImageArr;

    AFHTTPRequestOperationManager *_requestManager;
}

- (void)awakeFromNib {
    // Initialization code

    _btnImageArr = @[@"查看他人作品_未赞btn",@"查看他人作品_已赞btn"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configCellWithModel:(WIBMainModel *)infoModel
{
    self.infoModel = infoModel;
    self.headerBtn.layer.cornerRadius = 35.0;
    self.headerBtn.layer.masksToBounds = YES;

    [self.headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:infoModel.avatar] forState:UIControlStateNormal];

    self.nickname.text = infoModel.nickname;
    //学校
    self.schoolName.text = infoModel.school_str;
    //时间
    NSString *time = [infoModel.create_time substringFromIndex:5];
    self.address.text = [NSString stringWithFormat:@"上传:%@ |播放:%@",time,infoModel.views];
    //点赞数
    self.likeNum.text = infoModel.supports;

    //是否点赞
    NSInteger num = self.infoModel.ishow.integerValue;
    [self.lickBtn setBackgroundImage:[UIImage imageNamed:_btnImageArr[num]] forState:UIControlStateNormal];
    if (num) {
        self.likeNum.textColor = [UIColor greenColor];
    }
}
- (IBAction)lickBtnClick:(UIButton *)sender {

    //点赞
    NSInteger flag = self.infoModel.ishow.integerValue;
    NSInteger num = self.infoModel.supports.integerValue;

    [self.lickBtn setBackgroundImage:[UIImage imageNamed:_btnImageArr[1 - flag]] forState:UIControlStateNormal];
    if (flag) {
        self.infoModel.supports = [NSString stringWithFormat:@"%d",num - 1];
        self.likeNum.text = self.infoModel.supports;
        self.likeNum.textColor = [UIColor lightGrayColor];
    }else {
        self.infoModel.supports = [NSString stringWithFormat:@"%d",num + 1];
        self.likeNum.text = self.infoModel.supports;
        self.likeNum.textColor = [UIColor greenColor];
    }
    self.infoModel.ishow = [NSString stringWithFormat:@"%d",1 - flag];

    //需要post上传
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *parmae = @{
                             kPOST_1_AUTH_TOKEN:[user objectForKey:kTOKEN],
                             kPOST_2_SHOW_ID:self.infoModel.id,
                             kPOST_3_SHOW_UID:self.infoModel.uid,
                             kPOST_4_TYPE:@1,
                             kPOST_5_UID:[user objectForKey:kUID]
                             };
    [_requestManager POST:kPOST_SUPPORT_URL parameters:parmae success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)headerBtnClick:(UIButton *)sender {
    //点击头像 推出creater详情
    
}
@end
