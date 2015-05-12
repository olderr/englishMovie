//
//  AppDelegate.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//个人信息
#import "WIBUserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic , strong) WIBUserInfo *userInfo;

@end

