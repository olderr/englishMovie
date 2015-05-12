//
//  WIBSpecialCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBSpecialCell.h"
#import "UIImageView+WebCache.h"

@implementation WIBSpecialCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configCellWithModel:(WIBSpecialModel *)model
{
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    self.title.text = model.title;
    if (model.is_unlock.intValue == 1) {
        self.lockImage.hidden = YES;
    }else {
        self.lockImage.hidden = NO;
    }
}

@end
