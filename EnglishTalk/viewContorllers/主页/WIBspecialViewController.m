//
//  WIBspecialViewController.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBspecialViewController.h"
#import "WIBTabbarViewController.h"

#import "WIBSpecialModel.h"
#import "UIImageView+WebCache.h"
#import "WIBSpecialCell.h"
#import "WIBWantToDubViewController.h"
@interface WIBspecialViewController ()<UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>
{
    AFHTTPRequestOperationManager *_requestManager;
    //
    UICollectionView *_collectionView;
    //专辑详情
    UIView *_specialDetail;
}
@property (nonatomic , strong) NSMutableArray *dataArray;
@end

@implementation WIBspecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //定制Nav
    [self customNav];
    //下载数据
    [self requsetData];

    //
    [self createCollectionView];
    //
    [self createSpecialDetail];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tabbar的出现与隐藏
- (void)viewWillAppear:(BOOL)animated
{
    [(WIBTabbarViewController *)self.tabBarController setHiddenTabbar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [(WIBTabbarViewController *)self.tabBarController setShowTabbar];
}

#pragma mark - 定制Nav
- (void)customNav
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    title.text = @"专辑";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;

    UIView *btnBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnBg.userInteractionEnabled = YES;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(-22, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    [btnBg addSubview:leftBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btnBg];
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下载数据
- (void)requsetData
{
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSString *url = [NSString stringWithFormat:kSPECIAL_LIST,[user objectForKey:kTOKEN] , [user objectForKey:kUID] , self.model.id];
    NSLog(@"%@",url);
    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据分析
        [self analyseData:responseObject[@"data"]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"%@",error);
    }];
}
- (void)analyseData:(NSArray *)array
{
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    for (NSDictionary *dict in array) {
        WIBSpecialModel *model = [[WIBSpecialModel alloc]init];

        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    [_collectionView reloadData];
}

#pragma mark - 创建collectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 5;
    layout.itemSize = CGSizeMake(kWIDTH / 2 - 2, (kWIDTH / 2 - 2) * 0.6);

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWIDTH, kHEIGHT - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    UINib *cellNib = [UINib nibWithNibName:@"WIBSpecialCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"WIBSpecialCell"];

    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];

    [self.view addSubview:_collectionView];
}

#pragma mark - 创建专辑详情
- (void)createSpecialDetail
{
    _specialDetail = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWIDTH, kHEIGHT - 64)];
    _specialDetail.backgroundColor = [UIColor whiteColor];
    _specialDetail.userInteractionEnabled = YES;

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kWIDTH / 2)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic]];
    imageView.userInteractionEnabled = YES;

    UIView *blackView= [[UIView alloc]initWithFrame:CGRectMake(0, kWIDTH / 2 - 20, kWIDTH, 20)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.userInteractionEnabled = YES;

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, kWIDTH - 50, 20)];
    title.font = [UIFont systemFontOfSize:12];
    title.text = self.model.album_title;
    title.textColor = [UIColor whiteColor];

    [blackView addSubview:title];

    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(kWIDTH - 20, 0 ,20, 20)];
    [cancel setImage:[UIImage imageNamed:@"CancelContinualDubbingNoticeViewBtn"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];

    [blackView addSubview:cancel];

    //三个label
    NSArray *nameArr = @[@"专辑名称：",@"专辑难度：",@"专辑攻略："];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, kWIDTH / 2 + 20 * i, 60, 20)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:10];
        label.text = nameArr[i];
        [_specialDetail addSubview:label];
    }

    UILabel *specialName = [[UILabel alloc]initWithFrame:CGRectMake(5 + 60, kWIDTH / 2 , kWIDTH - 100, 20)];
    specialName.textColor = [UIColor lightGrayColor];
    specialName.font = [UIFont systemFontOfSize:10];
    specialName.text = self.model.album_title;
    [_specialDetail addSubview:specialName];

    for (int i = 0; i < 5; i++) {
        UIImageView *bgiv = [[UIImageView alloc]initWithFrame:CGRectMake(12 * i + 5 + 60, kWIDTH / 2 + 23, 12, 11)];
        if (i < self.model.dif_level.integerValue) {
            bgiv.image = [UIImage imageNamed:@"star2"];
        }else  {
            bgiv.image = [UIImage imageNamed:@"star-1"];
        }
        [_specialDetail addSubview:bgiv];
    }

    //详情
    UILabel *strategy = [[UILabel alloc]initWithFrame:CGRectMake(5 + 60, kWIDTH / 2 + 45, kWIDTH - 65 - 40, 20)];
    strategy.numberOfLines = 0;
    strategy.textColor = [UIColor lightGrayColor];
    strategy.font = [UIFont systemFontOfSize:10];
    strategy.text = self.model.myDescription;
    [strategy sizeToFit];

    [_specialDetail addSubview:strategy];
    [_specialDetail addSubview:imageView];
    [_specialDetail addSubview:blackView];

    [self.view addSubview:_specialDetail];
    [self.view sendSubviewToBack:_specialDetail];
}
- (void)cancelClick
{
    [self.view bringSubviewToFront:_collectionView];
}

#pragma mark - 协议方法
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//section头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader   withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
    if (reuseableView == nil) {
        reuseableView = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kWIDTH / 2)];
    }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:reuseableView.frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic]];
        [reuseableView addSubview:imageView];
        
        //i 44 * 44  player_bottomGradientBackColor
        UIView *bacView = [[UIView alloc]initWithFrame:CGRectMake(0, kWIDTH / 2 - 20, kWIDTH, 20)];
        bacView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_bottomGradientBackColor"]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWIDTH * 0.6, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = self.model.album_title;

        for (int i = 0; i < 5; i++) {
            UIImageView *bgiv = [[UIImageView alloc]initWithFrame:CGRectMake(12 * i + kWIDTH - 70, 4, 12, 11)];
            if (i < self.model.dif_level.integerValue) {
                bgiv.image = [UIImage imageNamed:@"star2"];
            }else  {
                bgiv.image = [UIImage imageNamed:@"star-1"];
            }
            [bacView addSubview:bgiv];
        }

        UIImageView *iIv = [[UIImageView alloc]initWithFrame:CGRectMake(kWIDTH - 10 - 44, 10, 44, 44)];
        iIv.image = [UIImage imageNamed:@"i"];

        [reuseableView addSubview:iIv];
        [bacView addSubview:label];
        [reuseableView addSubview:bacView];

        UIControl *control = [[UIControl alloc]initWithFrame:reuseableView.frame];
        [control addTarget:self action:@selector(detailClcik) forControlEvents:UIControlEventTouchDown];
        [reuseableView addSubview:control];

    return reuseableView;
}
//header的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kWIDTH , kWIDTH / 2);
}
- (void)detailClcik
{
    NSLog(@"detail");
    [self.view sendSubviewToBack:_collectionView];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WIBSpecialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WIBSpecialCell" forIndexPath:indexPath];
    WIBSpecialModel *model = self.dataArray[indexPath.row];
    [cell configCellWithModel:model];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WIBWantToDubViewController *wantVC =[[WIBWantToDubViewController alloc]init];
    WIBMainModel * model = self.dataArray[indexPath.row];
    if (model.url == nil) {
        wantVC.model = model;
    }else {
        wantVC.urlStr = model.url;
    }

    [self.navigationController pushViewController:wantVC animated:YES];
}
//锁遮罩.png 142 * 71
#pragma mark - 返回星级View
@end
