//
//  WIBMoiveDownCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBMoiveDownCtr.h"
#import "WIBMainModel.h"
#import "WIBCollectMovieCell.h"
#import "WIBWantToDubViewController.h"
@interface WIBMoiveDownCtr ()<UITableViewDataSource , UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic , strong)NSMutableArray *dataArray;
@end

@implementation WIBMoiveDownCtr

- (void)viewDidLoad {
    self.title = @"视频缓存";
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) style:UITableViewStylePlain];

    _tableView.delegate = self;
    _tableView.dataSource = self;

    UINib *cellNib = [UINib nibWithNibName:@"WIBCollectMovieCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:@"cell"];

    [self.view addSubview:_tableView];

    [self localArcheve];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 读取本地数据
- (void)localArcheve
{
    self.dataArray = [NSMutableArray arrayWithCapacity:10];

    NSString *basePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/archiver"];
    NSFileManager *manager = [NSFileManager defaultManager];

    NSArray *pathArray = [manager contentsOfDirectoryAtPath:basePath error:nil];
    NSLog(@"%@",pathArray);

    for (NSString *file in pathArray) {

        if ([file isEqualToString:@".DS_Store"]) {
            continue;
        }

        NSString *filePath = [NSString stringWithFormat:kMOVIE_INFO_ACHIVER_PATH , file];

        NSData *data = [NSMutableData dataWithContentsOfFile:filePath];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        WIBMainModel *model = [unarchiver decodeObjectForKey:@"model"];
        //解决归档完毕
        [unarchiver finishDecoding];

        [self.dataArray addObject:model];
    }
    [_tableView reloadData];
}

#pragma mark - 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWIDTH * 0.3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WIBCollectMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    WIBMainModel *model = self.dataArray[indexPath.row];

    [cell configItemWithModel:model];

    cell.time.text = nil;
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



@end
