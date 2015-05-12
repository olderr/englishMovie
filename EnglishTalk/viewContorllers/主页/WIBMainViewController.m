//
//  WIBMainViewController.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBMainViewController.h"

#import "UIImageView+WebCache.h"
//头部滚动视图
#import "GXCycleScrollView.h"
//数据模型
#import "WIBMainModel.h"
//cell
#import "WIBMainCollectionViewCell.h"
//collection view layout
#import "WIBCustomCVLayout.h"
//下拉刷新
#import "MJRefresh.h"
//点击视图推出视频播放
#import "WIBPlayMoiveDetailViewController.h"
//我要配音也
#import "WIBWantToDubViewController.h"
//专辑
#import "WIBspecialViewController.h"
//高手更多
#import "WIBMoreSupCtr.h"
//最新更多
#import "WIBNewMoreCtr.h"
#import "WIBOtherMoreCtr.h"
@interface WIBMainViewController ()<UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , GXCycleScrollViewDelegate>
{
    //视图(第一种方案 不能实施)
    UICollectionView *_collectionView;

    //下载
    AFHTTPRequestOperationManager *_requestManager;

    //存放每个section 的 course_id
    NSMutableArray *_courseArray;
    //存放每个section 的 module
    NSMutableArray *_moduleArray;
}
//存储数据
@property (nonatomic , strong)NSMutableDictionary *dataDict;
//存储标题
@property (nonatomic , strong)NSMutableArray *titleArray;
@end

@implementation WIBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    //数据下载
//    [self requestData];
    //定制Nav
    [self customNav];
    //创建Collection
    [self createCollection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#pragma mark - 获取uid token
//- (void)getUidUtoken
//{
//    NSUserDefaults
//}
#pragma mark - 定制Nav
- (void)customNav
{
    //left 英语趣配音logo 104 * 20
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    leftView.image = [UIImage imageNamed:@"英语趣视频.jpg"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];

    //right mainPageSearchIcon 50 * 45
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.userInteractionEnabled = YES;

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 50, 45)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"mainPageSearchIcon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:rightBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}
#pragma mark 搜索键点击
- (void)searchClick
{

}
#pragma mark - 数据下载
- (void)requestData
{
    //数据请求 开启HUD
    [SVProgressHUD showWithStatus:@"正在刷新..."];

    _requestManager = [AFHTTPRequestOperationManager manager];

    [_requestManager GET:kMIAN_URL_STR parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s 数据请求成功",__FUNCTION__);
        [self dataAnalyze:responseObject];
        //结束刷新
        [SVProgressHUD dismiss];
        [_collectionView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" 数据请求失败 %@",error);
    }];
}
- (void)dataAnalyze:(NSArray *)array
{
    if (self.dataDict == nil) {
        self.dataDict = [[NSMutableDictionary alloc]init];
    }else {
        [self.dataDict removeAllObjects];
    }
    if (self.titleArray == nil) {
        self.titleArray = [[NSMutableArray alloc]init];
    }else {
        [self.titleArray removeAllObjects];
    }
    if (_courseArray == nil) {
        _courseArray = [NSMutableArray array];
    }else {
        [_courseArray removeAllObjects];
    }
    if (_moduleArray == nil) {
        _moduleArray = [NSMutableArray array];
    }else {
        [_moduleArray removeAllObjects];
    }

    for (NSDictionary *dict in array) {

        if (dict == [array lastObject]) {
            continue;
        }

        NSString *selectKay = dict[@"module"];
        NSArray *subArr = dict[selectKay];
        NSMutableArray *needArr = [NSMutableArray arrayWithCapacity:5];
        if ([[dict allKeys] containsObject:@"id"] == YES) {
            [_courseArray addObject:dict[@"id"]];
        }else {
            [_courseArray addObject:[NSNull null]];
        }
        [_moduleArray addObject:dict[@"module"]];
        for (NSDictionary *subDict in subArr) {
            WIBMainModel *model = [[WIBMainModel alloc]init];
            [model setValuesForKeysWithDictionary:subDict];
            [needArr addObject:model];
        }
        [self.titleArray addObject:dict[@"title"]];
        [self.dataDict setObject:needArr forKey:dict[@"title"]];
    }
    [_collectionView reloadData];
}

#pragma mark - 创建Collection
- (void)createCollection
{
    UICollectionViewFlowLayout *customFL = [[UICollectionViewFlowLayout alloc]init];

    customFL.scrollDirection = UICollectionViewScrollDirectionVertical;
    customFL.minimumInteritemSpacing = 5;
    customFL.minimumLineSpacing = 5;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) collectionViewLayout:customFL];
    _collectionView.backgroundColor = [UIColor whiteColor];

    _collectionView.userInteractionEnabled = YES;

    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    //上拉刷新
    [self addRefresh];

    //注册普通cell
    UINib *cellNib = [UINib nibWithNibName:@"WIBMainCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
    //注册头部视图
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"scrollView"];
    //注册header
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"kindString"];
    
    [self.view addSubview:_collectionView];

}
//添加下拉刷新
- (void)addRefresh
{
    // 设置文字
    [_collectionView.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStateIdle];
    [_collectionView.header setTitle:@"松开可以刷新了" forState:MJRefreshHeaderStatePulling];
    [_collectionView.header setTitle:@"正在帮您刷新" forState:MJRefreshHeaderStateRefreshing];

    // 设置字体
    _collectionView.header.font = [UIFont systemFontOfSize:12];

    // 设置颜色
    _collectionView.header.textColor = [UIColor lightGrayColor];

    __weak typeof(self) weakSelf = self;
    [_collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    [_collectionView.header beginRefreshing];
}
#pragma mark - collection 代理
//分组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataDict.count;
}
//每个分组多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    NSString *title = self.titleArray[section];
    NSArray *temp = self.dataDict[title];
    return temp.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //头部滚动视图
    if (indexPath.section == 0) {
        UICollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scrollView" forIndexPath:indexPath];

        NSMutableArray *imagesArr = [NSMutableArray array];
        NSMutableArray *titleArr = [NSMutableArray array];
        for (WIBMainModel *model in self.dataDict[self.titleArray[indexPath.section]]) {
            [imagesArr addObject:model.pic];
            [titleArr addObject:model.title];
        }

        GXCycleScrollView *headerScrollView = [[GXCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kWIDTH / 2)];
        headerScrollView.titleArray = titleArr;
        headerScrollView.delegate = self;
        [headerScrollView setImageUrlNames:imagesArr animationDuration:2];
        [headerCell addSubview:headerScrollView];

        return headerCell;
    }

    WIBMainCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    WIBMainModel *model = [self.dataDict[self.titleArray[indexPath.section]] objectAtIndex:indexPath.row];

    [cell configItemWithModel:model];
    if (indexPath.section - 1 == 6) {
        cell.num.text = [self timeTransition:model.create_time];
        cell.icon6.hidden = YES;
        cell.icon.hidden = YES;
    }
    return cell;
}

//时间转换
- (NSString *)timeTransition:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";//2015-04-24 16:10"
    NSDate *createDate = [formatter dateFromString:dateStr];
    NSTimeInterval interval = [createDate timeIntervalSinceNow];
//    NSLog(@"str:%@ date :%@",dateStr,createDate);
    NSString *returnStr;
    if ((int)(8 * 60 - interval / 60) > 60) {
        returnStr = [NSString stringWithFormat:@"%d分钟前",(int)(-interval / 60)];
    }else {
        returnStr = [NSString stringWithFormat:@"%d小时前",(int)(-interval / 60 / 60)];
    }

    return returnStr;
}
//每个cell的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kWIDTH, kWIDTH / 2);
    }
    return CGSizeMake(kWIDTH / 2 - 5, kWIDTH / 2 / 2 + 5);
}
//返回headerview
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString * kindStr = @"kindString";
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kindStr forIndexPath:indexPath];

    if (headerView == nil) {
        headerView = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 15)];
    }
    //删除之前存在的子视图
    NSArray *subArray = headerView.subviews;
    for (UIView *view in subArray) {
        [view removeFromSuperview];
    }

    //添加标签
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(8, 15, 82, 15)];
    NSArray *headerImageArray = @[@"",@"首页_高手秀场_3.12",@"首页_热门视频_3.12",@"首页_专辑课程3.15",@"首页_动漫配音_3.12",@"首页_名人演说3.15",@"首页_听歌学习_3.12",@"首页_最新配音_3.12",@"首页_ishow专区_3.12"];
    iv.image = [UIImage imageNamed:headerImageArray[indexPath.section]];
    [headerView addSubview:iv];

    //添加button
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWIDTH - 44, 0, 44, 44)];
    rightBtn.tag = 10 + indexPath.section;
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"首页-更多3.12.btn"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchDown];
    if (indexPath.section != 0) {
        [headerView addSubview:rightBtn];
    }
    headerView.userInteractionEnabled = YES;
    return headerView;
}
//每个section的headerde的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(kWIDTH, 0.01);
    }
    return CGSizeMake(kWIDTH, 44);
}
//点击item的响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击了item
//    NSLog(@"%@",indexPath);
    if (indexPath.section == 1 || indexPath.section == 7) {
        WIBPlayMoiveDetailViewController *playMoive = [[WIBPlayMoiveDetailViewController alloc]init];
        playMoive.model = self.dataDict[self.titleArray[indexPath.section]][indexPath.row];
        [self.navigationController pushViewController:playMoive animated:YES];
    }else if (indexPath.section == 3) {
        WIBspecialViewController *special = [[WIBspecialViewController alloc]init];
        special.model = self.dataDict[self.titleArray[indexPath.section]][indexPath.row];

        [self.navigationController pushViewController:special animated:YES];

    }else {
        WIBWantToDubViewController *wantVC =[[WIBWantToDubViewController alloc]init];
        WIBMainModel * model = self.dataDict[self.titleArray[indexPath.section]][indexPath.row];
        if (model.url == nil) {
            wantVC.model = model;
        }else {
            wantVC.urlStr = model.url;
        }
        [self.navigationController pushViewController:wantVC animated:YES];
    }

}

#pragma mark - 点击更多的响应
- (void)moreClick:(UIButton *)btn
{
    if (btn.tag - 10 == 1) {
        //高手秀场
        WIBMoreSupCtr *supCtr = [[WIBMoreSupCtr alloc]init];
        [self.navigationController pushViewController:supCtr animated:YES];
    }else if (btn.tag - 10 == 7) {
        //最新配音
        WIBNewMoreCtr *newMore = [[WIBNewMoreCtr alloc]init];
        [self.navigationController pushViewController:newMore animated:YES];
    }else {
        WIBOtherMoreCtr *otherCtr = [[WIBOtherMoreCtr alloc]init];
        otherCtr.title = self.titleArray[btn.tag - 10];
        otherCtr.flag = _courseArray[btn.tag - 10];
        otherCtr.module = _moduleArray[btn.tag - 10];

        [self.navigationController pushViewController:otherCtr animated:YES];
    }
}
//mainPageMoreButton  向右箭头

#pragma mark - 滚动视图 的点击响应
- (void)cycleScrollView:(GXCycleScrollView *)cycleScrollView DidTapImageView:(NSInteger)index
{
    NSLog(@"%d",index);
    WIBWantToDubViewController *wantVC =[[WIBWantToDubViewController alloc]init];
    WIBMainModel * model = self.dataDict[self.titleArray[0]][index];
    if (model.url == nil) {
        wantVC.model = model;
    }else {
        wantVC.urlStr = model.url;
    }

    [self.navigationController pushViewController:wantVC animated:YES];
}

@end







