//
//  WIBTabbarViewController.h
//  QLV
//
//  Created by qianfeng on 15-4-16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBTabbarViewController : UITabBarController

- (void)selectViewController:(NSInteger)i;

- (void)setShowTabbar;

- (void)setHiddenTabbar;

@end
