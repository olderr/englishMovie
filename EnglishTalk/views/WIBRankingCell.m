//
//  WIBRankingCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBRankingCell.h"
#import "UIImageView+WebCache.h"

@implementation WIBRankingCell

- (void)awakeFromNib {
    // Initialization code
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
    self.avatar.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)tap:(UITapGestureRecognizer *)sender {
//
//    NSLog(@"%@",self.model.category_id);
//    
//}

- (void)configCell:(WIBMainModel *)model
{
    self.model = model;
//    [self.avatar.subviews[0] removeFromSuperview];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nickname.text = model.nickname;
    self.zanNum.text = model.supports;
}

@end
