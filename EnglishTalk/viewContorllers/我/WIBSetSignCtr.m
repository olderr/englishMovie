//
//  WIBSetSignCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBSetSignCtr.h"

@interface WIBSetSignCtr ()<UITextFieldDelegate , UIAlertViewDelegate>
{
    UITextField *_signTextField;
    UILabel *_textNum;

    AFHTTPRequestOperationManager *_requestManager;
}

@end

@implementation WIBSetSignCtr

- (void)dealloc
{

}


- (void)viewDidLoad {
    self.title = @"修改签名";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    _signTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64 + 20, kWIDTH, 40)];
    [_signTextField setBackgroundColor:[UIColor whiteColor]];
    _signTextField.delegate = self;
    _signTextField.text = self.sign;
    _signTextField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_signTextField];
    [_signTextField becomeFirstResponder];

    _signTextField.clearButtonMode = UITextFieldViewModeAlways;

    _textNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 + 20 + 40, kWIDTH, 40)];
    _textNum.text = [NSString stringWithFormat:@"%d  ",25 -  (int)_signTextField.text.length];
    _textNum.textAlignment = NSTextAlignmentRight;
    _textNum.font = [UIFont systemFontOfSize:15];
    _textNum.textColor = [UIColor lightGrayColor];
    _textNum.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textNum];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)textFieldChange
{
    _textNum.text = [NSString stringWithFormat:@"%d  ",25 -  (int)_signTextField.text.length];
    if (_signTextField.text.length >= 25) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入少于25个字" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.sign = _signTextField.text;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)confirmClick
{
    blockSign(self.sign);
    if(_requestManager == nil)
    {
        _requestManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    // auth_token=MTQyOTc4MDcwNLJ3smeAobqZ&signature=%E7%88%B1%E5%92%AF%E5%95%8Athey%E9%A5%BF%E4%BA%86%E5%8D%A1%E9%80%9A&uid=849259
    NSString *url = [NSString stringWithFormat:kPOST_SETTING_URL,kPOST_A_MEMBER];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSDictionary *para = @{
                           kPOST_1_AUTH_TOKEN:[user objectForKey:kTOKEN],
                           kPOST_SIGN : self.sign,
                           kPOST_5_UID : [user objectForKey:kUID]
                           };

    [_requestManager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBlockSign:(void (^)(NSString *))block
{
    blockSign = block;
}

@end
