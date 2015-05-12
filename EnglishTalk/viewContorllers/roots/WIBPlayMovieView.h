//
//  WIBPlayMovieView.h
//  EnglishTalk
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBPlayMovieView : UIView <UIGestureRecognizerDelegate>
{
    //播放按钮
    UIButton *_playBtn;
    //进度条
    UIProgressView *_progress;

    //应该是用slider
    UISlider *_slider;

    //全屏按钮
    UIButton *_fullScreenBtn;


    //设置一个block当点击屏幕的时候 屏幕旋转问题
    void (^_screenTranstion)(void);

}
- (instancetype)initWithFrame:(CGRect)frame withUrlStr:(NSString *)url withTitle:(NSString *)title;
//视频的标题
@property (nonatomic , copy)NSString *course_title;
//视频的url
@property (nonatomic , copy)NSString *movieUrlStr;

//视频停止播放
- (void)stopMovie;
//设置block
- (void)setScreenTranstionBlock:(void(^)(void))a;

@end
