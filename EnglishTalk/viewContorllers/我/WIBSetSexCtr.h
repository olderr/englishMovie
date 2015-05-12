//
//  WIBSetSexCtr.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBRoootCtr.h"

@interface WIBSetSexCtr : WIBRoootCtr
{
    void(^blockSexStr)(NSString *sex);
}

@property (nonatomic , copy)NSString *sex;

- (void)setBlockSexStr:(void(^)(NSString *))block;

@end
