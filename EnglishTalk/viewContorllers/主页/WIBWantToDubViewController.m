//
//  WIBWantToDubViewController.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBWantToDubViewController.h"
#import "WIBPlayMovieView.h"

#import "SVProgressHUD.h"
#import "WIBTabbarViewController.h"
#import "WIBRankingCell.h"
#import "PTEHorizontalTableView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#import "WIBPlayMoiveDetailViewController.h"

@interface WIBWantToDubViewController ()<PTETableViewDelegate>
{

//从上到下
    //整体
    UIScrollView *_mainScrollView;
    //视频播放
    WIBPlayMovieView *_moviePlay;
    //难度 下载 收藏
    UIView *_infoView;
    //详情
    UIView *_detailView;

    //本篇排行榜
    UIView *_rankingView;
    PTEHorizontalTableView *_rankingTable;
    NSMutableArray *_rankingDataArray;

    //相关课程
    UIView *_correlationView;
    PTEHorizontalTableView *_correlationTable;
    NSMutableArray *_correlationDataArray;
    //存放imageData Key

    NSMutableDictionary *_imagesDict;

//一个数据模型
    WIBMainModel *_oneModel;
    AFHTTPRequestOperationManager *_requestManager;

    SDWebImageManager *_cacheImageManager;

    //是否点赞
    NSNumber *_isCollect;
}

@end

@implementation WIBWantToDubViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UIView *barBg = [[UIView alloc]initWithFrame:CGRectMake(0, -20, kWIDTH, 20)];
    barBg.backgroundColor = [UIColor blackColor];
    [self.view addSubview:barBg];


    if (self.model == nil) {
        //下载数据
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
        NSLog(@"%@",self.urlStr);
        [_requestManager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //关闭HUD
            [SVProgressHUD dismiss];

            //数据在完成 一个字典
            _oneModel = [[WIBMainModel alloc]init];

            [_oneModel setValuesForKeysWithDictionary:responseObject];

            //刷新 配置UI
            [self configUI];
            

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@",error);
        }];

        //启动HUD
        [SVProgressHUD show];
    }else {
        _oneModel = self.model;
        [self configUI];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航条和tabber的隐藏
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [(WIBTabbarViewController *)self.tabBarController setHiddenTabbar];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [(WIBTabbarViewController *)self.tabBarController setShowTabbar];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

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
    [_moviePlay stopMovie];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 配置UI
- (void)configUI
{
    //详情的字符串
    NSString *str = [NSString stringWithFormat:@"%@ (上传by：%@) ",_oneModel.myDescription , _oneModel.editor];
    //字符串的告度
    CGFloat h = [WIBMyTools stringSizeWithString:str font:12].height;

#pragma mark 数据请求
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //下载本篇排行榜
    NSLog(@"%@",[NSString stringWithFormat:kWANT_TO_DUB_Url1 , [user objectForKey:kUID], _oneModel.id]);
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    [_requestManager GET:[NSString stringWithFormat:kWANT_TO_DUB_Url1 , [user objectForKey:kUID], _oneModel.id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据分析
        [self dataAnalyse:responseObject[@"data"] toDataSource:0];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fuck -- request 1%@",error);
    }];

    //下载课程推荐
    NSLog(@"%@",[NSString stringWithFormat:kWANT_TO_DUB_Url2 , _oneModel.id , [user objectForKey:kUID], [user objectForKey:kTOKEN]]);
    [_requestManager GET:[NSString stringWithFormat:kWANT_TO_DUB_Url2 , _oneModel.id , [user objectForKey:kUID] , [user objectForKey:kTOKEN]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据分析
        [self dataAnalyse:responseObject[@"data"] toDataSource:1];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fuck -- request 2%@",error);
    }];

    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.bounces = YES;
//    _mainScrollView.contentSize = CGSizeMake(kWIDTH, kHEIGHT * 1.5);
    _mainScrollView.showsVerticalScrollIndicator = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.userInteractionEnabled = YES;

    [self.view addSubview:_mainScrollView];

#pragma mark 本篇排行榜
    _rankingView = [[UIView alloc]initWithFrame:CGRectMake(0, kWIDTH / 2 + 3 + 44 + h + 20 + 25 + 10 + 25, kWIDTH, 110)];

    [_mainScrollView addSubview:_rankingView];
    UILabel *header1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 25)];
    header1.text = @"本篇排行榜";
    header1.textColor = [UIColor lightGrayColor];
    header1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]];
    header1.font = [UIFont systemFontOfSize:15];
    [_rankingView addSubview:header1];

    //创建本篇排行榜table
    [self createRankingTableView];
#pragma mark 相关课程
    _correlationView = [[UIView alloc]initWithFrame:CGRectMake(0, kWIDTH / 2 + 3 + 44 + h + 20 + 25 + 10 + 25 + 115, kWIDTH, 110)];
    [_mainScrollView addSubview:_correlationView];
    _mainScrollView.contentSize = CGSizeMake(kWIDTH, kWIDTH / 2 + 3 + 44 + h + 20 + 25 + 10 + 25 + 115 + 120);

    UILabel *header2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 25)];
    header2.text = @"相关课程";
    header2.textColor = [UIColor lightGrayColor];
    header2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]];
    header2.font = [UIFont systemFontOfSize:15];

    [_correlationView addSubview:header2];

    //创建相关课程table
    [self createCorrelationTable];

#pragma mark info难度 + 下载 + 收藏
    //23 * 21  star-1 灰色 、 star2 黄色
    //下载 44 * 44 下载a 下载b
    //收藏a 收藏b
    _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, kWIDTH / 2 + 1, kWIDTH, 45)];
    _infoView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_infoView];
    //难度
    UILabel *nanduLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 30, 44)];
    nanduLabel.textColor = [UIColor lightGrayColor];
    nanduLabel.text = @"难度";
    nanduLabel.font = [UIFont systemFontOfSize:13];
    [_infoView addSubview:nanduLabel];
    //star
    for (int i = 0; i < 5; i++) {
        UIImageView *bgiv = [[UIImageView alloc]initWithFrame:CGRectMake(12 * i + 50, 16, 12, 11)];
        if (i < _oneModel.dif_level.integerValue) {
            bgiv.image = [UIImage imageNamed:@"star2"];
        }else  {
            bgiv.image = [UIImage imageNamed:@"star-1"];
        }
        [_infoView addSubview:bgiv];
    }

    //下载
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kWIDTH - 44 - 44 - 10, 0, 44, 44)];

    UIImage *im1 = [UIImage imageNamed:@"下载a.png"];
    im1 = [im1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:im1 forState:UIControlStateNormal];
    [button setImage:[[UIImage imageNamed:@"下载b.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    button.tag = 11;
    [_infoView addSubview:button];

    //收藏
    UIButton *cBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWIDTH - 44, 0, 44, 44)];
    [cBtn setImage:[UIImage imageNamed:@"收藏a"] forState:UIControlStateNormal];
    [cBtn setImage:[UIImage imageNamed:@"收藏b"] forState:UIControlStateSelected];
    [cBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchDown];
    [_infoView addSubview:cBtn];
    cBtn.tag = 12;


#pragma mark 视频播放
    //判断是否存在本地文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *filePath = [path stringByAppendingFormat:@"/download/%@.mp4",self.model.title];
    NSFileManager *manager = [NSFileManager defaultManager];


    if ([manager fileExistsAtPath:filePath]) {
        //已经存在
        _moviePlay = [[WIBPlayMovieView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kWIDTH / 2) withUrlStr:filePath withTitle:_oneModel.title];
        //隐藏下载键
        button.hidden = YES;
    }else {
        //
        _moviePlay = [[WIBPlayMovieView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kWIDTH / 2) withUrlStr:_oneModel.video withTitle:_oneModel.title];
    }


    [_mainScrollView addSubview:_moviePlay];

    __weak typeof(_mainScrollView) weakScroll = _mainScrollView;
    __weak typeof(_moviePlay) weakMoviePlayView = _moviePlay;
    __weak typeof(self) weadSelf = self;
    [_moviePlay setScreenTranstionBlock:^{
        static int flag = 0;
        if (flag == 0) {
            //使屏幕变横向
            //bar方向
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
            [weakScroll bringSubviewToFront:weakMoviePlayView];
            [weadSelf.view bringSubviewToFront:weakScroll];
            NSLog(@"%d",flag);
            flag ++;
        }
        else {
            [weakScroll sendSubviewToBack:weakMoviePlayView];
            [weadSelf.view sendSubviewToBack:weakScroll];

            NSLog(@"%d",flag);
            flag --;
        }
    }];

#pragma mark - 详情 + 开启配音按键

//    NSLog(@"hh ====  %.2f",h);

    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, kWIDTH / 2 + 3 + 44, kWIDTH, h + 20 + 25 + 10 + 25)];
    _detailView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_detailView];

    //title
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, kWIDTH - 10, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:19];
    title.text = _oneModel.title;
    [_detailView addSubview:title];

    //description
    UIScrollView *descriptionScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kWIDTH, 90)];
    descriptionScroll.showsHorizontalScrollIndicator = NO;
    descriptionScroll.showsVerticalScrollIndicator = NO;
    [_detailView addSubview:descriptionScroll];

    UILabel *labelDes1 = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, kWIDTH - 6, h)];
    labelDes1.numberOfLines = 0;
    labelDes1.font = [UIFont systemFontOfSize:12];
    labelDes1.textColor = [UIColor blackColor];
    [descriptionScroll addSubview:labelDes1];

    labelDes1.attributedText = [self str2attributed:str];


    //开启配音button
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake((kWIDTH - 120) / 2 , h + 20 + 22, 120, 25)];
    [btn3 addTarget:self action:@selector(beginDub:) forControlEvents:UIControlEventTouchDown];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"fnyfx_btn"] forState:UIControlStateNormal];
    [btn3 setTitle:@"开启配音" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_detailView addSubview:btn3];

    [self customNav];

    //判断是否收藏
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }

    /*
     course_id
     uid
     auth_token
     */
    NSString *url = [NSString stringWithFormat:kGET_IS_COLLECT,self.model.id,[user objectForKey:kUID],[user objectForKey:kTOKEN]];
    NSLog(@"%@",url);
    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _isCollect = responseObject[@"status"];
        NSLog(@"_isCollect %@",_isCollect);
        UIButton *btn = (UIButton *)[self.view viewWithTag:12];
        if ([_isCollect isEqual:@1]) {
            [btn setSelected:YES];
        }else {
            [btn setSelected:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//下载
- (void)downClick:(UIButton *)btn
{
    [btn setSelected:!btn.isSelected];

    [self movieDownLoad];
}
//收藏
- (void)collectClick:(UIButton *)btn
{
    [btn setSelected:!btn.isSelected];
    /*
     auth_token=MTQyOTc4MDcwNLJ3smeAobqZ&course_id=8656&uid=849259
     */
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSDictionary *parase = @{
                             kPOST_1_AUTH_TOKEN:[user objectForKey:kTOKEN],
                             @"course_id":self.model.id,
                             kPOST_5_UID:[user objectForKey:kUID]
                             };

    if ([_isCollect isEqual: @1] == YES) {
        //已收藏
        NSLog(@"已经收藏 %@",_isCollect);
        [_requestManager POST:kPOST_COLLECT_CANCEL parameters:parase success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject[@"msg"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else {

        //尚未收藏
        NSLog(@"尚未收藏 %@",_isCollect);

        [_requestManager POST:kPOST_COLLECT parameters:parase success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject[@"msg"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
//开启配音
- (void)beginDub:(UIButton *)btn
{

}
#pragma mark - 刷新状态
- (void)refresh
{
    //下载
    UIButton *downBtn = (UIButton *)[self.view viewWithTag:11];

    //收藏
    UIButton *collectBtn = (UIButton *)[self.view viewWithTag:12];
}
#pragma mark - 数据分析
- (void)dataAnalyse:(NSArray *)array toDataSource:(NSInteger)flag;
{
    if (_rankingDataArray == nil) {
        _rankingDataArray = [NSMutableArray array];
    }
    if (_correlationDataArray == nil) {
        _correlationDataArray = [NSMutableArray array];
    }
    for (NSDictionary *dict in array) {
        WIBMainModel *model = [[WIBMainModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        if (flag == 0) {
            //第一个
            [_rankingDataArray addObject:model];
        }else {
            //第二个
            [_correlationDataArray addObject:model];
            //开启图片缓存
            [self myCacheImage:model.pic];
        }
    }
    [_rankingTable.tableView reloadData];
    [_correlationTable.tableView reloadData];
}
- (void)myCacheImage:(NSString *)urlStr
{
    if (_imagesDict == nil) {
        _imagesDict = [NSMutableDictionary dictionary];
        _cacheImageManager = [SDWebImageManager sharedManager];
    }

//    NSLog(@"模型中的 %@",urlStr);
    [_cacheImageManager downloadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (finished) {
            //将图片存放到字典

//            [_imagesDict setObject:UIImagePNGRepresentation(image) forKey:imageURL];

//            NSLog(@"存放key %@",imageURL);

            [_correlationTable.tableView reloadData];
        }
    }];
}
#pragma mark - tools
//计算字符串的大小
- (CGSize)calculateStrSize:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(kWIDTH - 10, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;

    return size;
}
//将字符串转换成attribute
- (NSAttributedString *)str2attributed:(NSString *)string
{
    NSRange range = [string rangeOfString:@"(上传by："];

    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute setAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor]} range:NSMakeRange(range.location, string.length - range.location)];

    return attribute;
}

#pragma mark - 创建本篇排行榜tableView
- (void)createRankingTableView
{
    _rankingTable = [[PTEHorizontalTableView alloc]initWithFrame:CGRectMake(0, 25, kWIDTH, 90)];
    _rankingTable.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, kWIDTH, 90) style:UITableViewStylePlain];
    _rankingTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rankingTable.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    _rankingTable.tableView.allowsSelection = YES;
    _rankingTable.delegate = self;

    UINib *cell1Nib = [UINib nibWithNibName:@"WIBRankingCell" bundle:nil];
    [_rankingTable.tableView registerNib:cell1Nib forCellReuseIdentifier:@"cell1"];

    [_rankingView addSubview:_rankingTable];
}
#pragma mark - 创建相关课程tableview
- (void)createCorrelationTable
{
    _correlationTable= [[PTEHorizontalTableView alloc]initWithFrame:CGRectMake(0, 25, kWIDTH, 80)];
    _correlationTable.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, kWIDTH, 80 ) style:UITableViewStylePlain];
    _correlationTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _correlationTable.tableView.allowsSelection = YES;
    _correlationTable.delegate = self;

    [_correlationView addSubview:_correlationTable];
}

#pragma mark - tableViewDelegate
- (NSUInteger)numberOfSectionsInTableView:(PTEHorizontalTableView *)horizontalTableView
{
    return 1;
}

- (NSInteger)tableView:(PTEHorizontalTableView *)horizontalTableView numberOfRowsInSection:(NSInteger)section
{
    if (horizontalTableView == _rankingTable) {
        return _rankingDataArray.count;
    }else if (horizontalTableView == _correlationTable) {

        return _correlationDataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(PTEHorizontalTableView *)horizontalTableView widthForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (horizontalTableView == _rankingTable) {
        return 70.0;
    }
    WIBMainModel *model =  _correlationDataArray[indexPath.row];

    return kWIDTH / 3.0;

//    CGSize size = [self jpgImageSizeWithHeaderData:_imagesDict[model.pic]];
//
//    return size.width * (size.height / 80.0);
}
- (UITableViewCell *)tableView:(PTEHorizontalTableView *)horizontalTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //排行榜
    if (horizontalTableView == _rankingTable) {
        WIBRankingCell *cell = [horizontalTableView.tableView dequeueReusableCellWithIdentifier:@"cell1"];
        WIBMainModel *model = _rankingDataArray[indexPath.row];
        [cell configCell:model];

        return cell;
    }
    //相关
    UITableViewCell *cell = [horizontalTableView.tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }else {
        NSArray *subViews = cell.constraints;
        for (UIView *iv in subViews) {
            [iv removeFromSuperview];
        }
    }
    WIBMainModel *model = _correlationDataArray[indexPath.row];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH / 3.0, 80)];


    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    //添加一个label
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 80 - 30, kWIDTH / 3.0, 30)];
    titleView.backgroundColor = [UIColor blackColor];
    titleView.alpha = 0.3;

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80 - 30, kWIDTH / 3.0, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = model.title;


    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:titleView];
    [cell.contentView addSubview:titleLabel];

    return cell;
}
#pragma mark - 横向tableview的点击时间
- (void)tableView:(PTEHorizontalTableView *)horizontalTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (horizontalTableView == _rankingTable) {
        //排行榜
        WIBMainModel *model = _rankingDataArray[indexPath.row];

        WIBPlayMoiveDetailViewController *playCtr = [[WIBPlayMoiveDetailViewController alloc]init];
        playCtr.model = model;
        [self.navigationController pushViewController:playCtr animated:YES];
    }else {
        WIBWantToDubViewController *wantDub = [[WIBWantToDubViewController alloc]init];
        wantDub.model = _correlationDataArray[indexPath.row];
        [self.navigationController pushViewController:wantDub animated:YES];

        //相关
//        [self.navigationController.viewControllers firstObject] pushViewController:self animated:
        NSLog(@"%@",self.navigationController.viewControllers);

    }
}



#pragma mark - tools 计算图片大小
- (CGSize)jpgImageSizeWithHeaderData:(NSData *)data
{
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}


#pragma mark - 视频下载
- (void)movieDownLoad
{
    NSString *filePath = [NSString stringWithFormat:kMOVIE_DOWNLOAD_PATH, self.model.title];
    NSLog(@"%@",filePath);
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath]) {
        //已经存在

    }else {
        //文件不存在
        NSString *savePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/download"];

        if (![manager fileExistsAtPath:savePath]) {
            //该文件夹不存在
            [manager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];

            [manager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/archiver"] withIntermediateDirectories:YES attributes:nil error:nil];
        }

        NSURL *url = [NSURL URLWithString:_oneModel.video];

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
        operation.inputStream = [NSInputStream inputStreamWithURL:url];
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        //下载进度控制
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            NSLog(@"下载进度%.2f",(float) totalBytesRead / totalBytesExpectedToRead);
        }];
        //将model归档

        [self movieModelArchave];

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        [_requestManager.operationQueue addOperation:operation];
        [operation start];
    }
}
#pragma mark - 添加归档
- (void)movieModelArchave
{
    NSMutableData *data = [[NSMutableData alloc]init];

    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:_oneModel forKey:@"model"];
    [archiver finishEncoding];

    [data writeToFile:[NSString stringWithFormat:kMOVIE_INFO_ACHIVER_PATH , _oneModel.title] atomically:YES];
}

#pragma mark - 点击相关课程时的block
- (void)setMainViewCotrollerSetWantToModel:(void (^)(WIBMainModel *))block
{
    mainViewCotrollerSetWantToModel = block;
}


@end
