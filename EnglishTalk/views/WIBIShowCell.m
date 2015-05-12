//
//  WIBIShowCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBIShowCell.h"
#import "UIImageView+WebCache.h"


@implementation WIBIShowCell
{
    AFHTTPRequestOperationManager *_requestManager;
}
- (void)awakeFromNib {
    // Initialization code
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
    self.avatar.layer.masksToBounds = YES;
//    [self.zanBTN setImage:[UIImage imageNamed:@"攒b"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configCellWithModel:(WIBIShowModel *)model
{
    self.model = model;
    //pic
    self.pic.image = nil;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    //title
    self.title.text = model.course_title;
    //avatar
    self.avatar.image = nil;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    //nickname
    self.nickname.text = model.nickname;
    //time
    self.time.text = [self calculateTime:model.create_time];
    //攒
    self.zanNum.text = model.supports;
    if ([model.is_support intValue] == 0) {
        //未攒
        [self.zanBTN setSelected:NO];
        self.zanNum.textColor = [UIColor greenColor];
    }else {
        [self.zanBTN setSelected:YES];
        self.zanNum.textColor = [UIColor orangeColor];
    }
}
//计算时间
- (NSString *)calculateTime:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //2015-04-25 19:05
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [formatter dateFromString:time];

    NSTimeInterval interval = [date timeIntervalSinceNow];
    //小时
    NSInteger mm = 8 * 60 - interval/60;
    //    NSLog(@"str :%@ date : %@ interval : %f mm: %d",time,date,interval,mm);
    if (mm >= 60 * 24) {
        return [NSString stringWithFormat:@"%d天前",(int)mm / 60 /24];
    }
    else if (mm >= 60) {
        return [NSString stringWithFormat:@"%d小时前",(int)mm / 60];
    }
    return [NSString stringWithFormat:@"%d分钟前",(int)mm];
}
- (IBAction)zanClick:(id)sender {

    UIButton *btn = (UIButton *)sender;
    NSInteger zanNum = self.model.supports.integerValue;
    NSString *supportStr;
    if (btn.isSelected == YES ) {
        [btn setSelected:NO];
        supportStr = [NSString stringWithFormat:@"%d",(int)zanNum - 1];
        self.zanNum.text = supportStr;

        self.zanNum.textColor = [UIColor greenColor];

    }else {
        [btn setSelected:YES];
        supportStr = [NSString stringWithFormat:@"%d",(int)zanNum + 1];
        self.zanNum.text = supportStr;

        self.zanNum.textColor = [UIColor orangeColor];
    }
    //需要post上传
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSNumber *support = @(1 - (long)self.model.is_support);
    NSDictionary *parmae = @{
                             kPOST_1_AUTH_TOKEN:[user objectForKey:kTOKEN],
                             kPOST_2_SHOW_ID:self.model.show_id,
                             kPOST_3_SHOW_UID:self.model.uid,
                             kPOST_4_TYPE:support,
                             kPOST_5_UID:[user objectForKey:kUID]
                             };
    [_requestManager POST:kPOST_SUPPORT_URL parameters:parmae success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.model.is_support = support;
        self.model.supports = supportStr;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
