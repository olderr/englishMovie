//
//  WIBSetSignCtr.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBRoootCtr.h"

@interface WIBSetSignCtr : WIBRoootCtr
{
    void (^blockSign)(NSString *sign);
}

@property (nonatomic , copy)NSString * sign;

- (void)setBlockSign:(void(^)(NSString *))block;

@end
