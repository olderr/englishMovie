//
//  WIBWantToDubViewController.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIBMainModel.h"

@interface WIBWantToDubViewController : UIViewController

//一个url
@property (nonatomic , copy)NSString *urlStr;

@property (nonatomic , strong)WIBMainModel *model;

@end
