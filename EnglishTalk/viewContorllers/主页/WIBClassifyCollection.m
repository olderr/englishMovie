//
//  WIBClassifyCollection.m
//  EnglishTalk
//
//  Created by qianfeng on 15-5-13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBClassifyCollection.h"

#define header_hight 30
#define item_hight 30

@implementation WIBClassifyCollection
{
    NSString *_natureIDValue;
    NSString *_levelValue;
    NSString *_sortValue;

    NSInteger _natureNum;
    NSInteger _levelNum;
    NSInteger _sortNum;
}


#pragma mark - 创建键盘
- (instancetype)initWithArray:(NSArray *)array
{
    self.dataArray = array;

    self.userInteractionEnabled = YES;
    if (self = [super init]) {

        _natureIDValue = @"all";
        _levelValue = @"all";
        _sortValue = @"new";

        _natureNum = 0;
        _levelNum = 0;
        _sortNum = 0;

        self.backgroundColor = [UIColor whiteColor];
        [self createKeyBoard];

    }
    return self;
}

- (void)configViewWithArray:(NSArray *)array
{
    self.dataArray = array;
    self.userInteractionEnabled = YES;

    self.backgroundColor = [UIColor whiteColor];
    [self createKeyBoard];
}

- (void)createKeyBoard
{
    //计算需要多少高度

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(kWIDTH / 5, item_hight);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;

    _keyboardCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(40, 0, kWIDTH - 40, [self countViewHight]) collectionViewLayout:flowLayout];
    _keyboardCollection.userInteractionEnabled = YES;

    _keyboardCollection.backgroundColor = [UIColor whiteColor];
    _keyboardCollection.delegate = self;
    _keyboardCollection.dataSource = self;
    _keyboardCollection.scrollEnabled = NO;

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
            h += ([dict[@"list"] count] / 4 + 1)* (item_hight + 5);
        }else {
            h += ([dict[@"list"] count] / 4)* (item_hight + 5);
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

    cell.layer.cornerRadius = item_hight / 2.0;
    cell.layer.masksToBounds = YES;
    cell.userInteractionEnabled = YES;
    [[cell.contentView.subviews lastObject] removeFromSuperview];
    [[cell.contentView.subviews firstObject] removeFromSuperview];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWIDTH / 5.0, item_hight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.dataArray[indexPath.section][@"list"][indexPath.row][@"name"];
    [cell.contentView addSubview:label];

    if ((indexPath.row == _natureNum && indexPath.section == 0) || (indexPath.row == _levelNum && indexPath.section == 1) || (indexPath.row == _sortNum && indexPath.section == 2)) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SearchPage_NoResultContectButton"]];
        label.textColor = [UIColor whiteColor];
    }else {
        label.textColor = [UIColor grayColor];
        cell.backgroundColor = [UIColor whiteColor];
    }

    cell.tag = (indexPath.section + 1) * 200 + indexPath.row;
//    NSLog(@"%ld",cell.tag);

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
//    static NSString *nature = @"all";
//    static NSString *level = @"new";
//    static NSString *sort = @"new";

    if (indexPath.section == 0) {
        _natureIDValue = self.dataArray[indexPath.section][@"list"][indexPath.row][@"value"];
        _natureNum = indexPath.row;
    }else if (indexPath.section == 1) {
        _levelValue = self.dataArray[indexPath.section][@"list"][indexPath.row][@"value"];
        _levelNum = indexPath.row;
    }else if (indexPath.section == 2){
        _sortValue = self.dataArray[indexPath.section][@"list"][indexPath.row][@"value"];
        _sortNum = indexPath.row;
    }

    ArgumentsBlock(_natureIDValue , _levelValue , _sortValue);
    [_keyboardCollection reloadData];
    
    return;
    //改变颜色

    for (int i = 0; i < [self.dataArray[indexPath.section][@"list"] count]; i++) {
        UICollectionViewCell *cell = (UICollectionViewCell *)[self viewWithTag:(indexPath.section + 1) * 200 + indexPath.row];
        UILabel *label = (UILabel *)cell.contentView.subviews[0];
        if (i == indexPath.row) {
            //点击的那个item
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SearchPage_NoResultContectButton"]];
            label.textColor = [UIColor whiteColor];
            NSLog(@"select %d",i);
        }else {
            label.textColor = [UIColor grayColor];
            cell.backgroundColor = [UIColor whiteColor];
            NSLog(@"normal %d",i);
        }
    }
}

- (void)setArgumentsBlock:(void (^)(NSString *, NSString *, NSString *))block
{
    ArgumentsBlock = block;
}

@end
