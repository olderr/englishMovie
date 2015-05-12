//
//  WIBIShowViewController.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WORD_TYPE){
    WORD_TYPE_ALL = 0,
    WORD_TYPE_SCHOOL,
    WORD_TYPE_WEEK
};
typedef NS_ENUM(NSUInteger, TIME_TYPE) {
    TIME_TYPE_DAY = 1,
    TIME_TYPE_WEEK
};

@interface WIBIShowViewController : UIViewController

@end
