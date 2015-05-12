//
//  WIBMainCollectionViewCell.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBMainCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WIBMainCollectionViewCell

- (void)awakeFromNib {
    // Initialization code    
}

- (void)allViewClear
{
    self.picImageView.image = [UIImage imageNamed:@"mainPageDefaultImg"];
    
    self.icon.image =  nil;
    self.title.text = nil;
    self.corner.hidden = YES;
    self.num.text = nil;
}

- (void)configItemWithModel:(WIBMainModel *)model
{
    if (model.album_title == nil) {
        self.corner.hidden = YES;
    }else {
        self.corner.hidden = NO;
    }
    self.num.text = model.views;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];


    if (model.nickname != nil) {
        self.title.text = model.nickname;
        self.icon6.hidden = YES;
        self.icon.hidden = NO;

    }else {
        self.icon6.hidden = NO;
        self.icon.hidden = YES;
    }

    if (model.title != nil ) {
        self.title.text = model.title;
    }else if (model.album_title != nil) {
        self.title.text = model.album_title;
    }
}

@end






