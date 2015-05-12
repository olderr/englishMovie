//
//  WIBPlayMoiveDetailViewController.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBPlayMoiveDetailViewController.h"
//视频播放
#import "WIBPlayMovieView.h"
//#import "VLCMediaPlayer.h"
//下载
#import "AFHTTPSessionManager.h"
//tabbar
#import "WIBTabbarViewController.h"
//存放评论的信息
#import "WIBCommentsModels.h"
//个人资料的cell
#import "WIBCreateMovieInfoTableViewCell.h"
//评论人得资料
#import "WIBCommentsTableViewCell.h"

@interface WIBPlayMoiveDetailViewController ()<UITableViewDataSource , UITableViewDelegate>
{
    //视频播放控制
//    VLCMediaPlayer *_mediaPlayer;

    //视频播放view
    WIBPlayMovieView *_moviePlayView;


    //视频控制
    NSTimer *_time;

    //滚动列表
    UITableView *_tableView;
    //底部view
    UIView *_footerView;
    //下载
    AFHTTPSessionManager *_requestManager;
}
//存放评论
@property (nonatomic , strong)NSMutableArray *dataArray;
@end

@implementation WIBPlayMoiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //视频播放
    [self createPlayView];

    //下载数据
    [self requsetData];

    //定制Nav
    [self customNav];

    //创建tableview
    [self createTableView];

    //创建footerView
    [self createFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 导航条和tabber的隐藏
- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    [(WIBTabbarViewController *)self.tabBarController setHiddenTabbar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [(WIBTabbarViewController *)self.tabBarController setShowTabbar];
}
#pragma mark - 视频播放
- (void)createPlayView
{
    _moviePlayView = [[WIBPlayMovieView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kWIDTH / 2) withUrlStr:self.model.video withTitle:self.model.course_title];
    [self.view addSubview:_moviePlayView];
#pragma mark - 视频播放view屏幕旋转的block

    __weak typeof(self) weakSelf = self;
    __weak typeof(_moviePlayView) weakMoviePlayView = _moviePlayView;
    [_moviePlayView setScreenTranstionBlock:^{
        static int flag = 0;
        if (flag == 0) {
            //使屏幕变横向
            //bar方向
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
            [weakSelf.view bringSubviewToFront:weakMoviePlayView];
            NSLog(@"%d",flag);
            flag ++;
        }
        else {
            [weakSelf.view sendSubviewToBack:weakMoviePlayView];
            NSLog(@"%d",flag);
            flag --;
        }
    }];
}

#pragma mark - 数据下载
- (void)requsetData
{
    _requestManager = [AFHTTPSessionManager manager];
    NSLog(@"%@",[NSString stringWithFormat:kMEDIA_ALL_COMMENT,self.model.id]);
    [_requestManager GET:[NSString stringWithFormat:kMEDIA_ALL_COMMENT,self.model.id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"media comment request ok");

        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
            [_tableView reloadData];
            return ;
        }
        
        //数据分析
        [self analyseData:responseObject];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)analyseData:(NSArray *)array
{
    if (self.dataArray.count == 0) {
        self.dataArray = [NSMutableArray array];
    }
    for (NSDictionary *dict  in array) {
        WIBCommentsModels *model = [[WIBCommentsModels alloc]init];
        if (dict.count == 0) {
            [_tableView reloadData];
            return;
        }
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }

    [_tableView reloadData];
}
#pragma mark - 定制Nav
- (void)customNav
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake( 15, 24, 20, 30)];
    [backBtn setImage:[UIImage imageNamed:@"latestArrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
}
- (void)backClick
{
    [_moviePlayView stopMovie];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 创建tableView
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kWIDTH / 2 , kWIDTH, kHEIGHT - kWIDTH/2 - 40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.bounces = NO;
    //注册cell1
    UINib *cellNid1 = [UINib nibWithNibName:@"WIBCreateMovieInfoTableViewCell" bundle:nil];
    [_tableView registerNib:cellNid1 forCellReuseIdentifier:@"cell1"];
    //注册cell2
    UINib *cellNid2 = [UINib nibWithNibName:@"WIBCommentsTableViewCell" bundle:nil];
    [_tableView registerNib:cellNid2 forCellReuseIdentifier:@"cell2"];

    [self.view addSubview:_tableView];
}

#pragma mark - 创建footerView
- (void)createFooterView
{
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT - 44, kWIDTH, 44)];
    _footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"down.png"]];

    //添加 button  phb_btn_pinglunnew  phb_btn_peiyinnew
//评论
    UIButton *commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 7, 85, 30)];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"phb_btn_pinglunnew"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchDown];
    [_footerView addSubview:commentBtn];
//我要配音
    UIButton *askForBtn = [[UIButton alloc]initWithFrame:CGRectMake((kWIDTH - 85) / 2 , 7, 85, 30)];
    [askForBtn setBackgroundImage:[UIImage imageNamed:@"phb_btn_peiyinnew"] forState:UIControlStateNormal];
    [askForBtn addTarget:self action:@selector(askForClick:) forControlEvents:UIControlEventTouchDown];
    [_footerView addSubview:askForBtn];

//分享 btn_share
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWIDTH - 75, 0, 71, 44)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchDown];
    [_footerView addSubview:shareBtn];

    [self.view addSubview:_footerView];
}
- (void)commentClick:(UIButton *)btn
{
    //弹出textFeild
}
- (void)askForClick:(UIButton *)btn
{
    //推出下一页 配音页

}
- (void)shareClick:(UIButton *)btn
{
    //推出下一页 分享
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80.0;
    }else {
        WIBCommentsModels *model = self.dataArray[indexPath.row];
        CGFloat hh = [[WIBCommentsTableViewCell alloc] calculateStringSize:model.comment].height;
        if (hh < 13) {
            return 70;
        }else
            return 70 - 13 + hh;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WIBCreateMovieInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];

        [cell configCellWithModel:self.model];

        return cell;
    }else {
        WIBCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        [cell configCellWithCommentModel:self.dataArray[indexPath.row]];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return 30.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, kWIDTH, 30)];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav"]];
    label.text = [NSString stringWithFormat:@"  评论（%@）",self.model.comments];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    return label;
}
//拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == 0) {
        scrollView.bounces = NO;
    }else {
        scrollView.bounces = YES;
    }
}
//上拉刷新
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + 20) {
        //触发上拉刷新
        if (self.model.comments.integerValue > 50) {
            //追加 请求数据
            [self requsetData];
        }
    }
}
@end
