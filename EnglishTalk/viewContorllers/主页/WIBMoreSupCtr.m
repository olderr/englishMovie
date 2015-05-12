//
//  WIBMoreSupCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBMoreSupCtr.h"
#import "WIBSupMoreModel.h"
#import "WIBSupMoreCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "WIBPlayMoiveDetailViewController.h"

@interface WIBMoreSupCtr ()<UITableViewDataSource , UITableViewDelegate>
{
    UITableView *_tableView;

    AFHTTPRequestOperationManager *_requestManager;
}
@property (nonatomic , strong)NSMutableArray *dataArray;
@end

@implementation WIBMoreSupCtr

- (void)viewDidLoad {
    self.title = @"高手秀场";

    [super viewDidLoad];
    //下载数据
    [self requsetData];
    //穿件tableview
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下砸数据
- (void)requsetData
{
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:kSUP_MORE_URL,[user objectForKey:kUID]];
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
        self.dataArray = [NSMutableArray array];
    }
    for (NSDictionary *dict in array) {
        WIBSupMoreModel *model = [[WIBSupMoreModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];

        [self.dataArray addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - 创建tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) style:UITableViewStylePlain];
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
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWIDTH / 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBSupMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fuck"];

    WIBSupMoreModel *model = self.dataArray[indexPath.row];

    [cell configCellWithModel:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBMainModel *model = self.dataArray[indexPath.row];
    WIBPlayMoiveDetailViewController *palyVC = [[WIBPlayMoiveDetailViewController alloc]init];
    palyVC.model = model;

    [self.navigationController pushViewController:palyVC animated:YES];

}

@end
