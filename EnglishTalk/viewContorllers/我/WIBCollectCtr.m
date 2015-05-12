//
//  WIBCollectCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBCollectCtr.h"
#import "WIBMainModel.h"
#import "WIBCollectMovieCell.h"
#import "WIBWantToDubViewController.h"

@interface WIBCollectCtr ()<UITableViewDataSource , UITableViewDelegate>
{
    UITableView *_tableView;
    AFHTTPRequestOperationManager *_requestManager;
}
@property (nonatomic , strong)NSMutableArray * dataArray;
@property (nonatomic , strong)NSMutableArray * timeArray;
@end

@implementation WIBCollectCtr

- (void)viewDidLoad {
    self.title = @"视频收藏";
    [super viewDidLoad];
    [self requestData];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 数据下载
- (void)requestData
{
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:kGET_COLLECT_MOIVE , [user objectForKey:kUID] , [user objectForKey:kTOKEN]];

    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据分析
        [self analyseArray:responseObject[@"data"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 数据分析
- (void)analyseArray:(NSArray *)array
{
    if (self.dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:10];
        self.timeArray = [NSMutableArray arrayWithCapacity:10];
    }
    for (NSDictionary *dict in array) {
        NSString *type = dict[@"type"];
        WIBMainModel *model = [[WIBMainModel alloc]init];
        [model setValuesForKeysWithDictionary:dict[type]];

        [self.dataArray addObject:model];
        [self.timeArray addObject:dict[@"create_time"]];
    }
    [_tableView reloadData];
}

#pragma mark - 创建tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *cellNib = [UINib nibWithNibName:@"WIBCollectMovieCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"cell"];

    [self.view addSubview:_tableView];
}
#pragma mark - 协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWIDTH * 0.3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBCollectMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    WIBMainModel *model = self.dataArray[indexPath.row];

    [cell configItemWithModel:model];

    cell.time.text = [self transformDate:self.timeArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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


- (NSString *)transformDate:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";//2015-04-24 16:10"
    NSDate *createDate = [formatter dateFromString:dateStr];
    NSTimeInterval interval = [createDate timeIntervalSinceNow];
    //    NSLog(@"str:%@ date :%@",dateStr,createDate);
    NSString *returnStr;
    if ((int)(8 * 60 - interval / 60) > 24 * 60) {
        returnStr = [dateStr substringFromIndex:5];
    }else {
        returnStr = [NSString stringWithFormat:@"%d小时前",(int)(-interval / 60 / 60)];
    }

    return returnStr;
}

@end
