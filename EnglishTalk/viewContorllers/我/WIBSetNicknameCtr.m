//
//  WIBSetNicknameCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBSetNicknameCtr.h"

@interface WIBSetNicknameCtr ()<UITextFieldDelegate , UIAlertViewDelegate>
{
    UITextField *_nickTextField;
    AFHTTPRequestOperationManager *_requestManager;
}

@end

@implementation WIBSetNicknameCtr

- (void)viewDidLoad {
    self.title = @"修改昵称";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nickTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64 + 20, kWIDTH, 40)];
    _nickTextField.text = self.nickname;
    _nickTextField.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    _nickTextField.textColor = [UIColor lightGrayColor];
    _nickTextField.delegate = self;
    _nickTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_nickTextField];
    [_nickTextField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *newNickname = textField.text;
    if (newNickname.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入用户名" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (_requestManager == nil) {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    //auth_token=MTQyOTc4MDcwNLJ3smeAobqZ&nickname=%E7%8E%8B%E6%80%BB&uid=849259
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *pares = @{
                            kPOST_1_AUTH_TOKEN:[user objectForKey:kTOKEN],
                            kPOST_NICKNAME:newNickname,
                            kPOST_5_UID:[user objectForKey:kUID]
                            };

    NSString *url = [NSString stringWithFormat:kPOST_SETTING_URL , kPOST_A_MEMBER];
    
    [_requestManager POST:url parameters:pares success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);

        blockNickname(newNickname);

        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写父类方法
- (void)customNav
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    title.text = self.title;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftView.userInteractionEnabled = YES;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(-22, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [leftBtn setTitle:@"我的资料" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor lightGrayColor]];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
    
    [leftView addSubview:leftBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];

    //右键
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
- (void)backClick
{
    [super backClick];
}
- (void)rightBtnClick
{
    [self textFieldShouldReturn:_nickTextField];
}

- (void)setBlockNickname:(void (^)(NSString *))block
{
    blockNickname = block;
}


@end
