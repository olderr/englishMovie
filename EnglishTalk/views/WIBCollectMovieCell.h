//
//  WIBCollectMovieCell.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBMainModel.h"

@interface WIBCollectMovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;

- (void)configItemWithModel:(WIBMainModel *)model;

@end
