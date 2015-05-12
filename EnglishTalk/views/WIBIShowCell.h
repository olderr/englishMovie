//
//  WIBIShowCell.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBIShowModel.h"

@interface WIBIShowCell : UITableViewCell

@property (nonatomic , strong) WIBIShowModel *model;

- (void)configCellWithModel:(WIBIShowModel *)model;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *zanNum;
@property (weak, nonatomic) IBOutlet UIButton *zanBTN;

- (IBAction)zanClick:(id)sender;


@end
