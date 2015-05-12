//
//  WIBCollectionReusableView.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBCollectionReusableView.h"

@implementation WIBCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:frame];
        iv.image = [UIImage imageNamed:@"MainPageBack3"];
        [self addSubview:iv];
    }
    return self;
}

@end
