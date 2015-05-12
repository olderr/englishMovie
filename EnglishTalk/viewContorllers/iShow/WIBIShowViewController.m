//
//  WIBIShowViewController.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBIShowViewController.h"

#import "MJRefresh.h"
#import "WIBIShowModel.h"
#import "WIBIShowCell.h"
#import "WIBPlayMoiveDetailViewController.h"
@interface WIBIShowViewController ()<UITableViewDataSource , UITableViewDelegate>
{
    AFHTTPRequestOperationManager *_requsetManager;
    
    NSString *_urlString;
    
    UITableView *_tableView;

    //作品类型
    WORD_TYPE _wordType;
    //时间类型
    TIME_TYPE _timeType;
}
@property (nonatomic , strong)NSMutableArray *dataArray;
@end

@implementation WIBIShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //赋初值
    _wordType = WORD_TYPE_ALL;
    _timeType = TIME_TYPE_DAY;

    [self createTableView];
    //定制nav
    [self custonNav];
    //创建btn
    [self createHeaderBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)requsetData
{
    if (_requsetManager == nil) {
        _requsetManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            NSMutableArray *mutArr = [[NSMutableArray alloc]initWithArray:@[[NSNull null],[NSNull null],[NSNull null]]];
            [self.dataArray addObject:mutArr];
        }
    }
    if (self.dataArray[_timeType - 1][_wordType] != [NSNull null] && _tableView.header.state
 == MJRefreshHeaderStateIdle) {

        [_tableView reloadData];
        return;
    }

    [SVProgressHUD showWithStatus:@"正在刷新..."];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    [_requsetManager GET:[NSString stringWithFormat:kISHOW_URL_STR,[user objectForKey:kUID],(int)_timeType,(int)_wordType] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        [self analyseData:responseObject[@"data"]];
        [SVProgressHUD dismiss];
        [_tableView.header endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [_tableView.header endRefreshing];
        NSLog(@"%@",error);
    }];
}
- (void)analyseData:(NSArray *)array
{
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in array) {
        WIBIShowModel *model = [[WIBIShowModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];

        [tempArr addObject:model];
    }

    [self.dataArray[_timeType - 1] replaceObjectAtIndex:_wordType withObject:tempArr];
    [_tableView reloadData];
}
#pragma mark - Nav
- (void)custonNav
{
    UILabel *titel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 80, 44)];

    titel.textColor = [UIColor blackColor];
    titel.font = [UIFont systemFontOfSize:15];
    titel.textAlignment = NSTextAlignmentCenter;
    titel.text = @"排行榜";
    self.navigationItem.titleView = titel;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 30)];

    [rightBtn setTitle:@"今日" forState:UIControlStateNormal];
    [rightBtn setTitle:@"本周" forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [rightBtn addTarget:self action:@selector(day2weekClick:) forControlEvents:UIControlEventTouchDown];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}
- (void)day2weekClick:(UIButton *)btn
{
    [btn setSelected:!btn.isSelected];
    _timeType = 3 - _timeType;
    [self requsetData];
}

#pragma mark - createHeaderBtn
- (void)createHeaderBtn
{
    UIView *btnBg = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWIDTH, 40)];
    btnBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底部bg.png"]];

    [self.view addSubview:btnBg];
    
    
    CGFloat x = kWIDTH / 3.0;
    NSArray *btnNames = @[@"全部作品",@"同城作品",@"同校作品"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x * i + 10, 0, x - 20, 40)];
        btn.tag = 40 + i;
        [btn addTarget:self action:@selector(btnChangeClick:) forControlEvents:UIControlEventTouchDown];

        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];

        [btn setTitle:btnNames[i] forState:UIControlStateNormal];

        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 38, x - 20, 1)];
        vi.backgroundColor = [UIColor clearColor];
        vi.tag = 30 + i;
        if (i == 0) {
            [btn setSelected:YES];
            vi.backgroundColor = [UIColor greenColor];
        }
        [btn addSubview:vi];
        [btnBg addSubview:btn];
    }
}
- (void)btnChangeClick:(UIButton *)btn
{
    for (int i = 0; i < 3; i++) {
        UIView *vi = (UIView *)[self.view viewWithTag:i + 30];
        UIButton *button = (UIButton *)[self.view viewWithTag:i + 40];
        if (i == btn.tag - 40) {
            vi.backgroundColor = [UIColor greenColor];
            [button setSelected:YES];
        }else {
            vi.backgroundColor = [UIColor clearColor];
            [button setSelected:NO];
        }
    }
    _wordType = btn.tag - 40;

    //数据的切换
    [self requsetData];
}

#pragma mark - tableView
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kWIDTH, kHEIGHT - 40 - 49) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view sendSubviewToBack:_tableView];
    UINib *cellNib = [UINib nibWithNibName:@"WIBIShowCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"cellcell"];

    [self.view addSubview:_tableView];

    [self addPullRefresh];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataArray[_timeType - 1][_wordType] == [NSNull null]) {
        return 0;
    }
    return [self.dataArray[_timeType - 1][_wordType] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ishow row hight : %f", (80.0 / 320.0) * kWIDTH);
    return (80.0 / 320.0) * kWIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBIShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellcell"];
    if (self.dataArray[_timeType - 1][_wordType] == [NSNull null]) {
        return nil;
    }
    WIBIShowModel *model = self.dataArray[_timeType - 1][_wordType][indexPath.row];

    [cell configCellWithModel:model];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBPlayMoiveDetailViewController *playMoive = [[WIBPlayMoiveDetailViewController alloc]init];

    playMoive.model = self.dataArray[_timeType - 1][_wordType][indexPath.row];

    [self.navigationController pushViewController:playMoive animated:YES];
}

#pragma mark - 下拉刷新
- (void)addPullRefresh
{
    [_tableView.header setTitle:@"下拉可以刷新了" forState:MJRefreshHeaderStatePulling];
    [_tableView.header setTitle:@"松开马上刷新" forState:MJRefreshHeaderStateWillRefresh];
    [_tableView.header setTitle:@"正在帮您刷新中" forState:MJRefreshHeaderStateRefreshing];
    
    _tableView.header.font = [UIFont systemFontOfSize:12];
    _tableView.header.textColor = [UIColor lightGrayColor];
    
    __weak typeof(self) weakSelf = self;

    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf requsetData];
    }];
    
    [_tableView.header beginRefreshing];
}

@end
