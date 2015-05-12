//
//  WIBCollectMovieCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBCollectMovieCell.h"

@implementation WIBCollectMovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configItemWithModel:(WIBMainModel *)model
{
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.pic]];

    self.title.text = model.title;
}

@end
