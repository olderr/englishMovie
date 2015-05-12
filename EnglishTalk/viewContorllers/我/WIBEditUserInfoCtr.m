//
//  WIBEditUserInfoCtr.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBEditUserInfoCtr.h"
#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
//昵称
#import "WIBSetNicknameCtr.h"
//性别
#import "WIBSetSexCtr.h"
//签名档
#import "WIBSetSignCtr.h"
#define ORIGINAL_MAX_WIDTH kWIDTH

@interface WIBEditUserInfoCtr ()<UITableViewDataSource , UITableViewDelegate , UIActionSheetDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate , VPImageCropperDelegate>
{
    UITableView *_tableView;

    NSArray *_nameArray;

    AFHTTPRequestOperationManager *_requsetManager;

    //存放picker滚筒的view
    UIView *_pickerView;
    //选择生日的滚筒
    UIDatePicker *_datePicker;
}
@end

@implementation WIBEditUserInfoCtr

- (void)viewDidLoad {
    self.title = @"我的资料";
    [super viewDidLoad];

    _nameArray = @[@[@"更换头像"],@[@"昵称",@"性别",@"生日",@"签名"],@[@"学校",@"地区"],@[@"账号管理"]];

    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green: 240 / 255.0 blue:240 / 255.0 alpha:1];

    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建tableView
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
}
#pragma mark - 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    NSArray *subViews = cell.contentView.subviews;
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor whiteColor];

    UILabel *nameLabel = [[UILabel alloc]init];
    if (indexPath.section == 0) {
        nameLabel.frame = CGRectMake(15, 40 - 7, 80, 16);
    }else {
        nameLabel.frame = CGRectMake(15, 25 - 7, 80, 16);
    }
    nameLabel.text = _nameArray[indexPath.section][indexPath.row];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor grayColor];

    [cell.contentView addSubview:nameLabel];

    switch (indexPath.section) {
        case 0:
        {
            //更换头像
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWIDTH - 70 - 15, 10 , 60, 60)];
            imageView.tag = 200;
            imageView.layer.cornerRadius = 30.0;
            imageView.layer.masksToBounds = YES;

            [imageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar]];

            [cell.contentView addSubview:imageView];
        }
            break;
        default:
        {
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kWIDTH - 20, 17, 9, 16)];
            arrow.image = [UIImage imageNamed:@"shezhi_arrow-"];
            [cell.contentView addSubview:arrow];

            NSString *labelStr;

            if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    //昵称
                    labelStr = self.userInfo.nickname;
                }else if (indexPath.row == 1) {
                    //性别
                    if ([self.userInfo.sex isEqualToString:@"1"]) {
                        labelStr = @"男";
                    }else {
                        labelStr = @"女";
                    }
                }else if (indexPath.row == 2) {
                    //生日
                    labelStr = self.userInfo.birthday;
                }else {
                    //qmd
                    labelStr = self.userInfo.signature;
                }
            }
            else if (indexPath.section == 2) {
                if (indexPath.row == 0) {
                    //学校
                    labelStr = self.userInfo.school_str;
                }else {
                    //地区
                    labelStr = self.userInfo.area;
                }
            }
            else {
                //账号管理
            }
            CGFloat x = [self widthOfString:labelStr];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWIDTH - 25 - x , 25 - 7, x, 14)];
            titleLabel.text = labelStr;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:titleLabel];
        }
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80.0;
    }

    return 50.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            //修改头像
            UIActionSheet *chose = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册获取", nil];
            [chose showInView:self.view];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //nickname
                    WIBSetNicknameCtr *nickCtr = [[WIBSetNicknameCtr alloc]init];
                    nickCtr.nickname = self.userInfo.nickname;
                    [nickCtr setBlockNickname:^(NSString *name) {
                        self.userInfo.nickname = name;
                        [_tableView reloadData];
                    }];
                    [self.navigationController pushViewController:nickCtr animated:YES];
                    break;
                }
                case 1:
                {
                    //sex
                    WIBSetSexCtr *sexCtr = [[WIBSetSexCtr alloc]init];
                    sexCtr.sex = self.userInfo.sex;
                    [sexCtr setBlockSexStr:^(NSString *sex) {
                        self.userInfo.sex = sex;
                        [_tableView reloadData];
                    }];
                    [self.navigationController pushViewController:sexCtr animated:YES];

                    break;
                }
                case 2:
                {
                    //brith
                    [self createDatePick];
                    break;
                }
                case 3:
                {
                    //qmd
                    WIBSetSignCtr *signCtr = [[WIBSetSignCtr alloc]init];
                    signCtr.sign = self.userInfo.signature;
                    [signCtr setBlockSign:^(NSString *newSign) {
                        self.userInfo.signature = newSign;
                        [_tableView reloadData];
                    }];
                    [self.navigationController pushViewController:signCtr animated:YES];
                    break;
                }
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //school
                    
                }
                    break;
                case 1:
                {
                    //area
                }
                default:
                    break;
            }
        }
    }
}
#pragma mark - actionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }

    UIImagePickerController *pickerCtr = [[UIImagePickerController alloc]init];
    pickerCtr.delegate = self;

    if (buttonIndex == 0) {
        //拍照
        //判断相机是否可以启用
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            pickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }else if (buttonIndex == 1) {
        //相册
        pickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:pickerCtr animated:YES completion:nil];
}

#pragma mark - UIImagePickerCtr代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - VPImage 协议方法 获取裁剪后的图片
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    UIImageView *iv = (UIImageView *)[self.view viewWithTag:200];
    iv.image = editedImage;
    //将获取的图片上传服务器
    [self postAvatarToHostWithImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - tools
- (CGFloat)widthOfString:(NSString *)string
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(100, 50) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
    return size.width;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");

    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
//将图片上传服务器
- (void)postAvatarToHostWithImage:(UIImage *)image
{
    //获取沙盒目录
//    NSString *path = NSHomeDirectory();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *filePath = [path stringByAppendingPathComponent:@"image.jpg"];
    [imageData writeToFile:filePath atomically:NO];

    if (_requsetManager == nil) {
        _requsetManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    NSString *url = [NSString stringWithFormat:kPOST_SETTING_URL , kPOST_A_AVATAR];

    _requsetManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [_requsetManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[(NSString *)[user objectForKey:kTOKEN] dataUsingEncoding:NSUTF8StringEncoding] name:kPOST_1_AUTH_TOKEN];
        [formData appendPartWithFormData:[(NSString *)[user objectForKey:kUID] dataUsingEncoding:NSUTF8StringEncoding] name:kPOST_5_UID];
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:filePath mimeType:@"image/jpg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 创建datePicker
- (void)createDatePick
{
    if (_datePicker) {
        _pickerView.frame = CGRectMake(0, kHEIGHT - 216 - 40, kWIDTH, 216 + 40);
    }else {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, kWIDTH, 216)];
        _datePicker.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];

        _datePicker.datePickerMode = UIDatePickerModeDate;
        //设置最大值
        _datePicker.maximumDate = [NSDate date];
        //设置最小值
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:@"1920-01-01"];
        _datePicker.minimumDate = date;

        _pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, kHEIGHT, kWIDTH, 216 + 40)];
        _pickerView.userInteractionEnabled = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerView addSubview:_datePicker];

        //添加两个button
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchDown];
        [_pickerView addSubview:cancelBtn];
        //确定
        UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWIDTH - 40, 0, 40, 40)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(comfirmBtnClick) forControlEvents:UIControlEventTouchDown];
        [_pickerView addSubview:confirmBtn];
        [self.view addSubview:_pickerView];
        [self.view bringSubviewToFront:_pickerView];

        [UIView animateWithDuration:1 animations:^{
            _pickerView.frame = CGRectMake(0, kHEIGHT - 216 - 40 , kWIDTH, 216 + 40);
        }];
    }
    [_datePicker addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
}
- (void)cancelBtnClick
{
    //datepicker 取消
    _pickerView.frame = CGRectMake(0, kHEIGHT, kWIDTH, 216 + 40);
}
- (void)comfirmBtnClick
{
    [self cancelBtnClick];
    //detepicker 确定
    if (_requsetManager == nil) {
        _requsetManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    //auth_token=MTQyOTc4MDcwNLJ3smeAobqZ&birthday=2010-02-01&uid=849259

    NSString *url = [NSString stringWithFormat:kPOST_SETTING_URL,kPOST_A_MEMBER];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *parame = @{
                             kPOST_1_AUTH_TOKEN:[user objectForKey:kTOKEN],
                             kPOST_BRITH:self.userInfo.birthday,
                             kPOST_5_UID:[user objectForKey:kUID]
                             };
    [_requsetManager POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)datePickerChange:(UIDatePicker *)datePick
{
    NSDate *date = datePick.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *brith = [formatter stringFromDate:date];
    self.userInfo.birthday = brith;
}
@end
