//
//  WIBRankingCell.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBMainModel.h"


@interface WIBRankingCell : UITableViewCell

@property (nonatomic , strong)WIBMainModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (weak, nonatomic) IBOutlet UIImageView *zanIcon;
@property (weak, nonatomic) IBOutlet UILabel *zanNum;

//- (IBAction)tap:(UITapGestureRecognizer *)sender;
//
//@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

- (void)configCell:(WIBMainModel *)model;

@end
