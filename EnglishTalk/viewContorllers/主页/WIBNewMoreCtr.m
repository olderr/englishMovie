//
//  WIBNewMoreCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBNewMoreCtr.h"
#import "WIBSupMoreModel.h"
#import "WIBSupMoreCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "WIBPlayMoiveDetailViewController.h"

@interface WIBNewMoreCtr ()<UITableViewDataSource , UITableViewDelegate>
{
    UITableView *_tableView;

    AFHTTPRequestOperationManager *_requestManager;

    //存储url参数
    NSArray *_filterNames;
    //标识
    NSUInteger _flag;
}
@property (nonatomic , strong)NSMutableArray *dataArray;


@end

@implementation WIBNewMoreCtr

- (void)viewDidLoad {
    self.title = @"最新配音";

    [super viewDidLoad];
    _filterNames = @[@"all",@"school",@"follows"];
    _flag = 0;
    //定制Nav
//    [self customNav];
    //创建button
    [self createChangeBtn];
    //下载数据
    [self requsetData];
    //穿件tableview
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - 定制Nav
//- (void)customNav
//{
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    title.text = @"最新配音";
//    title.font = [UIFont systemFontOfSize:15];
//    title.textColor = [UIColor grayColor];
//    title.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = title;
//
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(-20, 0, 44, 44)];
//    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//}
//- (void)backClick
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - 创建button
- (void)createChangeBtn
{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWIDTH, 30)];
    btnView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav"]];
    btnView.userInteractionEnabled = YES;
    [self.view addSubview:btnView];

    NSArray *names =@[@"全部",@"本校",@"关注"];
    CGFloat x = kWIDTH / 3.0;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x * i, 0,x , 30)];
        [btn setTitle:names[i] forState:UIControlStateNormal];

        [btn setBackgroundImage:[UIImage imageNamed:@"灰色底"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"底部bg"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.tag = 50 + i;
        [btn addTarget:self action:@selector(filterChoice:) forControlEvents:UIControlEventTouchDown];
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 27, x, 2)];
        barView.tag = 60 + i;
        if (i == 0) {
            barView.backgroundColor = [UIColor greenColor];
            [btn setSelected:YES];
        }else {
            barView.backgroundColor = [UIColor grayColor];
        }
        [btn addSubview:barView];
        [btnView addSubview:btn];
    }

}
- (void)filterChoice:(UIButton *)btn
{
    for (int i = 0; i < 3; i++) {
        UIView *barView = (UIView *)[self.view viewWithTag:60 + i];
        UIButton *button = (UIButton *)[self.view viewWithTag:50 + i];
        if (i == btn.tag - 50) {
            barView.backgroundColor = [UIColor greenColor];
            [button setSelected:YES];
        }else {
            barView.backgroundColor = [UIColor grayColor];
            [button setSelected:NO];
        }
    }
    _flag = btn.tag - 50;
    [self requsetData];
}

#pragma mark - 下砸数据
- (void)requsetData
{
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSMutableArray *subMutableArr = [NSMutableArray array];
            [self.dataArray addObject:subMutableArr];
        }
    }
    if ([self.dataArray[_flag] count] > 0) {
        [_tableView reloadData];
        return;
    }

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:kNEW_MORE_URL,[user objectForKey:kUID],_filterNames[_flag]];
    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据分析
        [self analyseData:responseObject[@"data"]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)analyseData:(NSArray *)array
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        WIBSupMoreModel *model = [[WIBSupMoreModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];

        [temp addObject:model];
    }
    self.dataArray[_flag] = temp;

    [_tableView reloadData];
}

#pragma mark - 创建tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64 + 30, kWIDTH, kHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    UINib *cellNib = [UINib nibWithNibName:@"WIBSupMoreCell" bundle: nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"fuck"];

    [self.view addSubview:_tableView];
}

#pragma mark - tableview协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[_flag] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWIDTH / 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBSupMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fuck"];

    WIBSupMoreModel *model = self.dataArray[_flag][indexPath.row];

    [cell configCellWithModel:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBMainModel *model = self.dataArray[_flag][indexPath.row];
    NSLog(@"%@",model);
    WIBPlayMoiveDetailViewController *palyVC = [[WIBPlayMoiveDetailViewController alloc]init];
    palyVC.model = model;

    [self.navigationController pushViewController:palyVC animated:YES];
}


@end
