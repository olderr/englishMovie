//
//  WIBSupMoreCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBSupMoreCell.h"
#import "UIImageView+WebCache.h"

@implementation WIBSupMoreCell

- (void)awakeFromNib {
    // Initialization code
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.masksToBounds = YES;
//    [self.like setBackgroundImage:[UIImage imageNamed:@"关注后状态"] forState:UIControlStateSelected];
//    [self.like setTitle:@"已关注" forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)lickClick:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}
- (void)configCellWithModel:(WIBSupMoreModel *)model
{
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.createTime.text = [model.create_time substringFromIndex:5];
    self.nickname.text = model.nickname;
    self.address.text = model.school_str;
    self.movieNmae.text = [NSString stringWithFormat:@"发布了《%@》的配音",model.course_title];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    self.playNum.text = [NSString stringWithFormat:@"播放次数：%@",model.views];
    [self.like setSelected:model.is_following.integerValue];
}
@end
