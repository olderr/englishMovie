//
//  WIBPlayMovieView.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBPlayMovieView.h"
#import "VLCMediaPlayer.h"
#import "VLCTime.h"
@implementation WIBPlayMovieView
{
    UIView *_bgView;

    //开启定时器
    NSTimer *_timer;

    //视频播放
    VLCMediaPlayer *_mediaPlayer;
//上边条
    UIView *_upView;
    //title
    UILabel *_title;
//下边条
    UIView *_downView;
    //进度label
    UILabel *_progressLabel;

    //总时间换算成float
    CGFloat totalTime;

    //视频上的开始button
    UIButton *_actionBtn;
}

- (instancetype)initWithFrame:(CGRect)frame withUrlStr:(NSString *)url withTitle:(NSString *)title
{
    self.movieUrlStr = url;
    self.course_title = title;

    if (self = [super initWithFrame:frame]) {
        _bgView = [[UIView alloc]initWithFrame:self.frame];
        _bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_bg"]];
        [self addSubview:_bgView];

        _mediaPlayer = [[VLCMediaPlayer alloc]init];

        NSLog(@"%@",self.movieUrlStr);
        if ([self.movieUrlStr rangeOfString:@"http"].length == 0) {
            //本地文件
            _mediaPlayer.media = [VLCMedia mediaWithPath:self.movieUrlStr];
        }else {
            _mediaPlayer.media = [VLCMedia mediaWithURL:[NSURL URLWithString:self.movieUrlStr]];
        }

        _mediaPlayer.drawable = _bgView;

        [self customView];

        //添加手势
        [self addGesture];
    }
    return self;
}
- (void)customView
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_bg"]];
    self.userInteractionEnabled = YES;
//上边条
    _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 40)];
    [_upView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"player_topGradientBackColor"]]];
    _upView.userInteractionEnabled = YES;
    [self addSubview:_upView];

    //标题
    _title = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, kWIDTH - 100, 15)];
    _title.font = [UIFont systemFontOfSize:12];
    _title.backgroundColor = [UIColor clearColor];
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;

    _title.text = self.course_title;
    [_upView addSubview:_title];

//下边条
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 36, kWIDTH, 36)];
    _downView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_bottomGradientBackColor"]];
    _downView.userInteractionEnabled = YES;
    [self addSubview:_downView];

    //播放按键
    _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 36)];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"player_video_a_btu"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"player_video_b_btu"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(moviePlay:) forControlEvents:UIControlEventTouchDown];
    [_downView addSubview:_playBtn];

    //进度条
    _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(45, 18, kWIDTH - 90, 36)];
    _progress.trackTintColor = [UIColor whiteColor];
    _progress.progressTintColor = [UIColor greenColor];
    //原始状态
    _progress.progressImage = [UIImage imageNamed:@"player_slideThumbImage1"];
    //选中状态
//    _progress.progressImage = [UIImage imageNamed:@"player_slideThumbImage2"];
    _progress.progress = 0.01;
//    [_downView addSubview:_progress];

    //slider
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(45, 5, kWIDTH - 90, 25)];


    UIImage *thumb1 = [self image:[UIImage imageNamed:@"player_slideThumbImage1"] byScalingToSize:CGSizeMake(25, 25)];
    UIImage *thumb2 = [self image:[UIImage imageNamed:@"player_slideThumbImage2"] byScalingToSize:CGSizeMake(25, 25)];


    [_slider setThumbImage:thumb1 forState:UIControlStateNormal];
    [_slider setThumbImage:thumb2 forState:UIControlStateHighlighted];


    _slider.minimumValue = 0;
    _slider.maximumValue = 0.99;

    _slider.minimumTrackTintColor = [UIColor greenColor];
    _slider.maximumTrackTintColor = [UIColor grayColor];

    [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    
    [_downView addSubview:_slider];

    //全屏的按键
    _fullScreenBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWIDTH - 45, 0, 45, 36)];
    [_fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"player_fullScreen"] forState:UIControlStateNormal];
    [_fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"player_smallScreen"] forState:UIControlStateSelected];
    [_fullScreenBtn addTarget:self action:@selector(fullScreenClick:) forControlEvents:UIControlEventTouchDown];
    [_downView addSubview:_fullScreenBtn];

    //进度的时间
    _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWIDTH - 45 - 50, 24, 50, 10)];
    _progressLabel.textColor = [UIColor whiteColor];
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.font = [UIFont systemFontOfSize:8];
    _progressLabel.text = @"00:00/00:00";
    [_downView addSubview:_progressLabel];

    //action button
    _actionBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - 16 , self.frame.size.height / 2 - 16, 32, 32)];
    [_actionBtn setBackgroundImage:[UIImage imageNamed:@"player_video_a_btu"] forState:UIControlStateNormal];
    [_actionBtn addTarget:self action:@selector(resetPlayer) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_actionBtn];
    _actionBtn.hidden = YES;


    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshMovieInfo) userInfo:nil repeats:YES];
    [_timer fire];
}
- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClickOne:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate =self;
    [_bgView addGestureRecognizer:tap];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClcikTwo:)];
    tap2.numberOfTapsRequired = 2;
    tap2.delegate = self;
    [_bgView addGestureRecognizer:tap2];

    [tap requireGestureRecognizerToFail:tap2];
}
- (void)tapClickOne:(UITapGestureRecognizer *)tap
{
    //显示或者隐藏

    static int i = 1;
    if (i) {
        [UIView animateWithDuration:1 animations:^{
            _upView.alpha = 0.01;
            _downView.alpha = 0.01;
        }];
        i = 0;
    }else {
        [UIView animateWithDuration:1 animations:^{
            _upView.alpha = 1;
            _downView.alpha = 1;
        }];
        i = 1;
    }
}

- (void)tapClcikTwo:(UITapGestureRecognizer *)tap
{
    //全屏或者缩小
    NSLog(@"tap2");
    [self fullScreenClick:nil];
}

//滑块的滑动
- (void)sliderChange:(UISlider *)slider
{
    //比例和时间的换算
    
    [_mediaPlayer setTime:[[VLCTime alloc] initWithNumber:[NSNumber numberWithFloat:slider.value * totalTime * 1000]]];
}

//视频播放与暂停
- (void)moviePlay:(UIButton *)btn
{
    static VLCTime *oldTime;
    if (btn.isSelected == YES) {
        [btn setSelected:NO];
        [_mediaPlayer pause];
        [_timer setFireDate:[NSDate distantFuture]];
        oldTime = _mediaPlayer.time;
    }else {
        [btn setSelected:YES];
        [_mediaPlayer play];
        [_timer fire];
        if (oldTime != nil) {
//            [_mediaPlayer setTime:oldTime];
        }
    }
}
//屏幕的全屏与缩放
- (void)fullScreenClick:(UIButton *)btn
{
    static int i = 0;
    static CGRect oldFrame = self.frame;
    if (i == 0) {
        //横屏
        self.transform = CGAffineTransformMakeScale(kWIDTH / self.frame.size.height ,  kHEIGHT / self.frame.size.width);
        self.transform = CGAffineTransformRotate(self.transform,M_PI_2);
        self.center = CGPointMake(kWIDTH / 2, kHEIGHT / 2);

        self.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
        i++;
    }else {
        //竖屏
        self.transform = CGAffineTransformRotate(self.transform , -M_PI_2);

        self.transform = CGAffineTransformScale(self.transform , oldFrame.size.height / kWIDTH, oldFrame.size.width / kHEIGHT);
        self.center = CGPointMake(oldFrame.size.width / 2, oldFrame.size.height / 2);
        self.frame = oldFrame;
        i--;
    }
    _screenTranstion();
}

//定时器刷新
- (void)refreshMovieInfo
{
    //title的刷新
    static NSString *total;
    //定时隐藏
    static int hiddenViewTime = 0;
    if (hiddenViewTime++ == 6 && _upView.alpha == 1) {
        [self tapClickOne:nil];
        hiddenViewTime = 0;
    }
    if ([_mediaPlayer.time.stringValue isEqualToString:@"00:00"] && totalTime == 0) {
        total = [NSString stringWithFormat:@"%@",_mediaPlayer.remainingTime.stringValue];
        total = [total substringFromIndex:1];

        //计算时间
        NSArray *array = [total componentsSeparatedByString:@":"];
        totalTime = [array[0] floatValue] * 60 + [array[1] floatValue];

    }if (total != nil) {
        _progressLabel.text = [NSString stringWithFormat:@"%@/%@",_mediaPlayer.time,total];

        //进度条的刷新
        //计算时间
        NSArray *array = [_mediaPlayer.time.stringValue componentsSeparatedByString:@":"];
        CGFloat currentTime = [array[0] floatValue] * 60 + [array[1] floatValue];

        _slider.value = currentTime / totalTime ;
//        NSLog(@"%f",_slider.value);
        if (_slider.value >= 0.99) {
            //视频播放停止
            _actionBtn.hidden = NO;

            _slider.value = 0.01;

            [self sliderChange:_slider];

            [_mediaPlayer pause];
        }
    }
}
//视频重新播放
- (void)resetPlayer
{
    _actionBtn.hidden = YES;

    [_mediaPlayer play];
}

- (void)stopMovie
{
    [_mediaPlayer stop];
    [_timer setFireDate:[NSDate distantFuture]];
}
//改变图片大小
- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {

    UIImage *sourceImage = image;
    UIImage *newImage = nil;

    UIGraphicsBeginImageContext(targetSize);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage ;
}
//设置回调
- (void)setScreenTranstionBlock:(void(^)(void))a
{
    _screenTranstion = a;
}


@end
