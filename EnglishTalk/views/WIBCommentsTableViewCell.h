//
//  WIBCommentsTableViewCell.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBCommentsModels.h"

@interface WIBCommentsTableViewCell : UITableViewCell

@property (nonatomic , strong)WIBCommentsModels *model;

@property (weak, nonatomic) IBOutlet UIButton *headerIconBtn;

@property (weak, nonatomic) IBOutlet UILabel *nickname;

@property (weak, nonatomic) IBOutlet UILabel *beforeTime;

@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
- (IBAction)headerIconBtnClick:(UIButton *)sender;
- (IBAction)answerClick:(id)sender;

- (CGSize)calculateStringSize:(NSString *)contentStr;

- (void)configCellWithCommentModel:(WIBCommentsModels *)model;

@end
