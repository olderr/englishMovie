//
//  WIBSpecialCell.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBSpecialModel.h"

@interface WIBSpecialCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (weak, nonatomic) IBOutlet UIImageView *lockImage;
@property (weak, nonatomic) IBOutlet UILabel *title;

- (void)configCellWithModel:(WIBSpecialModel *)model;

@end
