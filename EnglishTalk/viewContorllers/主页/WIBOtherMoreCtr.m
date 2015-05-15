//
//  WIBOtherMoreCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBOtherMoreCtr.h"
#import "WIBTabbarViewController.h"

#import "WIBMainModel.h"
#import "WIBMainCollectionViewCell.h"
#import "UIViewExt.h"

//分类键view
#import "WIBClassifyCollection.h"

#import "WIBspecialViewController.h"
#import "WIBWantToDubViewController.h"

@interface WIBOtherMoreCtr ()<UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>
{
    AFHTTPRequestOperationManager *_requestManager;

    /*
     nature_id
     level
     sort
     */

//    NSString *_natureIDValue;
//    NSString *_levelValue;
//    NSString *_sortValue;

    UICollectionView *_collectionView;

    WIBClassifyCollection *_classifyView;
}
@property (nonatomic , copy)NSString *natureIDValue;
@property (nonatomic , copy)NSString *levelValue;
@property (nonatomic , copy)NSString *sortValue;

//保存键盘
@property (nonatomic , strong)NSMutableArray *keyboardDataArr;
//保存数据
@property (nonatomic , strong)NSMutableArray *dataArray;

@end

@implementation WIBOtherMoreCtr

- (void)viewDidLoad {

    [super viewDidLoad];
    _natureIDValue = @"all";
    _levelValue = @"all";
    _sortValue = @"new";
    self.view.backgroundColor = [UIColor orangeColor];
    self.view.userInteractionEnabled = YES;
    [self customNavRightBtn];
    //首先下载键盘
    [self requestKeyboard];
    //下载数据
    [self requestData];
    //创建collection
    [self createCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定制Nav
- (void)customNavRightBtn
{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    rightView.userInteractionEnabled = YES;

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 0, 50, 45)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"mainPageSearchIcon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchDown];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}
- (void)searchClick
{

}


#pragma mark - 键盘请求
- (void)requestKeyboard
{
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    if (self.keyboardDataArr == nil) {
        self.keyboardDataArr = [NSMutableArray array];
    }
    if (self.flag == [NSNull null]) {
        self.flag = @"(null)";
    }

    [_requestManager.operationQueue cancelAllOperations];

    NSString *url = [NSString stringWithFormat:kOTHER_KEYBOARD_URL , self.module , self.flag];
    NSLog(@"button %@",url);
    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.keyboardDataArr = responseObject[@"data"];

//        _classifyView = [[WIBClassifyCollection alloc]initWithArray:self.keyboardDataArr];


//        [self.view addSubview:_classifyView];
        //创建collection
//        [self createCollection];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 视频的请求
- (void)requestData
{
    /**其他更多的视频 请求
     参数
     category_id
     auth_token
     uid
     nature_id
     level
     sort
     */
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url;
    
    if ([self.module isEqualToString:@"album"]) {
        //专辑
        url = [NSString stringWithFormat:kOTHER_ALBUM , _natureIDValue , _levelValue];
    }else {
        url = [NSString stringWithFormat:kOTHER_MOVIE_URL , self.flag , [user objectForKey:kTOKEN] , [user objectForKey:kUID] , _natureIDValue , _levelValue , _sortValue];
    }

    NSLog(@"data url : %@",url);
    
    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据分析
        [self analyseData:responseObject[@"data"]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}
- (void)analyseData:(NSArray *)array
{
    if (self.dataArray.count == 0) {
        self.dataArray = [NSMutableArray arrayWithCapacity:10];
    }else {
        [self.dataArray removeAllObjects];
    }

    for (NSDictionary *dict in array) {

        WIBMainModel *model = [[WIBMainModel alloc]init];

        [model setValuesForKeysWithDictionary:dict];
        
        [self.dataArray addObject:model];

    }
    [_collectionView reloadData];
}

#pragma mark - 创建collectionView
- (void)createCollection
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(kWIDTH / 2, kWIDTH / 4);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 4;

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor]
    ;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.userInteractionEnabled = YES;

    UINib *items = [UINib nibWithNibName:@"WIBMainCollectionViewCell" bundle:nil];
    [_collectionView registerNib:items forCellWithReuseIdentifier:@"item"];

    [_collectionView registerClass:[WIBClassifyCollection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - collection的协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WIBMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];

    WIBMainModel *model = self.dataArray[indexPath.row];

    [cell configItemWithModel:model];

    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
//    NSLog(@"%f",_classifyView.viewHeight);
    WIBClassifyCollection *classify = [[WIBClassifyCollection alloc]initWithArray:self.keyboardDataArr];
    return CGSizeMake(kWIDTH, classify.viewHeight);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WIBClassifyCollection *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];


    if (headerView == nil) {
        headerView = [[WIBClassifyCollection alloc]init];
    }
    __weak WIBOtherMoreCtr *weakSelf = self;

    [headerView setArgumentsBlock:^(NSString *nature, NSString *level, NSString *sort) {

        self.natureIDValue = nature;
        self.levelValue = level;
        self.sortValue = sort;

        //重新请求数据
        [_requestManager.operationQueue cancelAllOperations];
        [weakSelf requestData];
    }];
    [headerView configViewWithArray:self.keyboardDataArr];

    return headerView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.module isEqualToString:@"album"]) {
        //专辑
        WIBspecialViewController *special = [[WIBspecialViewController alloc]init];
        special.model = self.dataArray[indexPath.row];

        [self.navigationController pushViewController:special animated:YES];

    }else {
        WIBWantToDubViewController *wantVC =[[WIBWantToDubViewController alloc]init];

        WIBMainModel * model = self.dataArray[indexPath.row];
        if (model.url == nil) {
            wantVC.model = model;
        }else {
            wantVC.urlStr = model.url;
        }
        [self.navigationController pushViewController:wantVC animated:YES];
    }
}
@end
