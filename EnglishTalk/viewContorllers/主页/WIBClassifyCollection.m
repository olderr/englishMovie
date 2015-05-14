//
//  WIBClassifyCollection.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBClassifyCollection.h"

#define header_hight 40
#define item_hight 40

@implementation WIBClassifyCollection
{
    NSString *_natureIDValue;
    NSString *_levelValue;
    NSString *_sortValue;
}


#pragma mark - 创建键盘
- (instancetype)initWithArray:(NSArray *)array
{
    self.dataArray = array;
//    NSLog(@"%@",self.dataArray);
    self.userInteractionEnabled = YES;
    if (self = [super init]) {

        _natureIDValue = @"all";
        _levelValue = @"all";
        _sortValue = @"new";

        self.backgroundColor = [UIColor whiteColor];
        [self createKeyBoard];
    }
    return self;
}

- (void)createKeyBoard
{
    //计算需要多少高度

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(kWIDTH / 5, kWIDTH / 10);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;

    _keyboardCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(40, 0, kWIDTH - 40, [self countViewHight]) collectionViewLayout:flowLayout];
    _keyboardCollection.userInteractionEnabled = YES;

    _keyboardCollection.backgroundColor = [UIColor whiteColor];
    _keyboardCollection.delegate = self;
    _keyboardCollection.dataSource = self;
//    _keyboardCollection.scrollEnabled = NO;

    //注册item
    [_keyboardCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    //注册header
    [_keyboardCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];


    [self addSubview:_keyboardCollection];

    [_keyboardCollection reloadData];
}

#pragma mark - 计算高度
- (CGFloat)countViewHight
{
    CGFloat h = header_hight * self.dataArray.count;
    for (NSDictionary *dict in self.dataArray) {
        if ([dict[@"list"] count] / 4 < [dict[@"list"] count] / 4.0) {
            h += ([dict[@"list"] count] / 4 + 1)* item_hight;
        }else {
            h += ([dict[@"list"] count] / 4)* item_hight;
        }
    }
    self.viewHeight = h;
    return h;
}

#pragma mark - 协议方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kWIDTH, header_hight);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *subArray = self.dataArray[section][@"list"];

    return subArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SearchPage_NoResultContectButton"]];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }

    cell.layer.cornerRadius = 20.0;
    cell.layer.masksToBounds = YES;
    cell.userInteractionEnabled = YES;
    [[cell.contentView.subviews lastObject] removeFromSuperview];
    [[cell.contentView.subviews firstObject] removeFromSuperview];
    UIButton *buttn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWIDTH / 5.0, item_hight)];

    buttn.tag = indexPath.row * 100 + indexPath.row;
    [buttn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWIDTH / 5.0, item_hight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = self.dataArray[indexPath.section][@"list"][indexPath.row][@"name"];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:buttn];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if (headerView == nil) {
        headerView = [[UICollectionReusableView alloc]init];
    }
    [[headerView.subviews lastObject] removeFromSuperview];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, header_hight)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.dataArray[indexPath.section][@"name"];

    [headerView addSubview:label];

    return headerView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _natureIDValue = self.dataArray[indexPath.section][@"value"];
    }else if (indexPath.row == 1) {
        _levelValue = self.dataArray[indexPath.section][@"value"];
    }else {
        _sortValue = self.dataArray[indexPath.section][@"value"];;
    }
    ArgumentsBlock(_natureIDValue , _levelValue , _sortValue);
}
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag/100 == 0) {
        _natureIDValue = self.dataArray[btn.tag%100][@"value"];
    }else if (btn.tag/100 == 1) {
        _levelValue = self.dataArray[btn.tag%100][@"value"];
    }else {
        _sortValue = self.dataArray[btn.tag%100][@"value"];;
    }
    ArgumentsBlock(_natureIDValue , _levelValue , _sortValue);
}
- (void)setArgumentsBlock:(void (^)(NSString *, NSString *, NSString *))block
{
    ArgumentsBlock = block;
}

@end
