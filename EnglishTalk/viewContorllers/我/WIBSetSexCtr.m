//
//  WIBSetSexCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBSetSexCtr.h"

@interface WIBSetSexCtr ()<UITableViewDataSource , UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    AFHTTPRequestOperationManager *_requestManager;
}

@end

@implementation WIBSetSexCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"男",@"女"];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;

    [self.view addSubview:_tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    NSArray *subViews = cell.contentView.subviews;
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 30, 30)];
    label.text = _dataArray[indexPath.row];
    label.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:label];

    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(kWIDTH - 50, 15, 30, 30)];
    iv.image = [UIImage imageNamed:@"ok"];
    [cell.contentView addSubview:iv];
    iv.tag = 200 + indexPath.row;
    if (indexPath.row + 1 == [self.sex integerValue]) {
        iv.hidden = NO;
    }else {
        iv.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *iv1 = (UIImageView *)[self.view viewWithTag:200 + indexPath.row];
    iv1.hidden = NO;


    UIImageView *iv2 = (UIImageView *)[self.view viewWithTag:200 + 1 - indexPath.row];
    iv2.hidden = YES;


    self.sex = [NSString stringWithFormat:@"%d",(int)indexPath.row + 1];
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    // auth_token=MTQyOTc4MDcwNLJ3smeAobqZ&sex=2&uid=849259
    NSDictionary *paras = @{
                            kPOST_1_AUTH_TOKEN : [user objectForKey:kTOKEN],
                            @"sex" : self.sex,
                            kPOST_5_UID : [user objectForKey:kUID]
                            };
    NSString *url = [NSString stringWithFormat:kPOST_SETTING_URL,kPOST_A_MEMBER];
    [_requestManager POST:url parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"性别 = %@ %@",self.sex,responseObject);

        blockSexStr(self.sex);

        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)setBlockSexStr:(void(^)(NSString *))block
{
    blockSexStr = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
