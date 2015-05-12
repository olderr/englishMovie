//
//  WIBSetNicknameCtr.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBRoootCtr.h"

@interface WIBSetNicknameCtr : WIBRoootCtr
{
    void(^blockNickname)(NSString *);
}

- (void)setBlockNickname:(void(^)(NSString*))block;

@property (nonatomic , copy)NSString *nickname;

@end
