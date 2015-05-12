//
//  WIBOtherMoreCtr.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBRoootCtr.h"

@interface WIBOtherMoreCtr : WIBRoootCtr
//Nav的标题
@property (nonatomic , copy)NSString *title;
//按键请求参数
@property (nonatomic , copy)NSString *flag;
//视频模块
@property (nonatomic , copy)NSString *module;
@end
