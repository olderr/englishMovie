//
//  WIBSupMoreCell.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBSupMoreModel.h"
@interface WIBSupMoreCell : UITableViewCell

@property (nonatomic , strong)WIBSupMoreModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UIButton *like;

@property (weak, nonatomic) IBOutlet UILabel *movieNmae;

@property (weak, nonatomic) IBOutlet UIImageView *pic;

@property (weak, nonatomic) IBOutlet UILabel *playNum;
- (IBAction)lickClick:(UIButton *)sender;

- (void)configCellWithModel:(WIBSupMoreModel *)model;

@end
