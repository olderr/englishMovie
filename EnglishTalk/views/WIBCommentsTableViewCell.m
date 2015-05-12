//
//  WIBCommentsTableViewCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBCommentsTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation WIBCommentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configCellWithCommentModel:(WIBCommentsModels *)model
{
    if (self.model == nil) {
        self.model = [[WIBCommentsModels alloc]init];
    }
    self.model = model;
    //头像
    self.headerIconBtn.layer.cornerRadius = 25.0;
    self.headerIconBtn.layer.masksToBounds = YES;
    [self.headerIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal];

    //此处需要判断comment里是否有回复
    NSRange range = [model.comment rangeOfString:@"回复@"];

    if (range.length > 0 && range.location > 0) {
        //判断里面存在子字符串
        //nickname 为attributeStr
        NSArray *strArr = [model.comment componentsSeparatedByString:@":"];
        //回复
        self.model.comment = strArr[1];
        //nickname 处理
        NSString *nicknameStr = strArr[0];
        nicknameStr = [nicknameStr stringByReplacingOccurrencesOfString:@"回复@" withString:@" 回复 "];
        NSMutableAttributedString *nicknameAttributeStr = [[NSMutableAttributedString alloc]initWithString:nicknameStr];

        [nicknameAttributeStr setAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} range:NSMakeRange(range.location, 4)];
        self.nickname.attributedText = nicknameAttributeStr;
    }else {

        //昵称
        self.nickname.text = model.nickname;

    }

    //时间
    self.beforeTime.text = [self calculateTime:model.create_time];

    //内容
    CGRect frame = self.contentText.frame;
    frame.size = [self calculateStringSize:self.model.comment];
    self.contentText.frame = frame;
//    NSLog(@"%@",self.model.comment);
    self.contentText.text = self.model.comment;

    //回复的button
    //清楚button上之前存在的
    NSArray *subViews = [self.answerBtn subviews];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    self.answerBtn.frame = CGRectMake(kWIDTH - 10 - 88, 0, 88, 44);
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    iv.image = [UIImage imageNamed:@"回复按钮icon"];
    [self.answerBtn addSubview:iv];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(44, 0, 44, 44)];
    label.text = @"回复";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blueColor];
    [self.answerBtn addSubview:label];
}
- (IBAction)headerIconBtnClick:(UIButton *)sender {
    //点击进去该评论人的资料
    
}

- (IBAction)answerClick:(id)sender {
    //进行评论
    
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

//计算字符串大小
- (CGSize)calculateStringSize:(NSString *)contentStr
{
    //NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(kWIDTH - 130, 900) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    return size;
}

@end












