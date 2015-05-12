//
//  WIBCreateMovieInfoTableViewCell.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//存放个人信息的model
#import "WIBMainModel.h"
@interface WIBCreateMovieInfoTableViewCell : UITableViewCell

@property (nonatomic , strong) WIBMainModel *infoModel;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;


@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *likeNum;

@property (weak, nonatomic) IBOutlet UIButton *lickBtn;

- (IBAction)lickBtnClick:(UIButton *)sender;
- (IBAction)headerBtnClick:(UIButton *)sender;

- (void)configCellWithModel:(WIBMainModel *)infoModel;

@end
