//
//  WIBCustomCVLayout.m
//  EnglishTalk
//
//  Created by qianfeng on 15-4-24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WIBCustomCVLayout.h"
//定制decoration
#import "WIBCollectionReusableView.h"

@implementation WIBCustomCVLayout

//准备
- (void)prepareLayout
{
    [super prepareLayout];
    [self registerClass:[WIBCollectionReusableView class] forDecorationViewOfKind:@"decoration"];
}
//内容大小
- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}
//item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.size = CGSizeMake(kWIDTH / 2 - 10, kWIDTH / 2 / 2 + 10);
    return attribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];

    if (indexPath.section == 0) {
        attribute.frame = CGRectMake(0, 0, kWIDTH, 1550);
        attribute.zIndex = -1;

        return attribute;
    }
    return nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributeArr = [NSMutableArray array];

    [attributeArr addObject:[self layoutAttributesForDecorationViewOfKind:@"decoration" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    return attributeArr;
}

@end
