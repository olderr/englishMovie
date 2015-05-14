//
//  WIBClassifyCollection.h
//  EnglishTalk
//
//  Created by qianfeng on 15-5-13.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBClassifyCollection : UIView <UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>
{
    //键盘的collection
    UICollectionView *_keyboardCollection;
    //block
    void(^ArgumentsBlock)(NSString *, NSString *, NSString *);
}
@property (nonatomic , assign)CGFloat viewHeight;

@property (nonatomic , strong)NSMutableArray *dataArray;

- (instancetype)initWithArray:(NSArray *)array;

- (void)setArgumentsBlock:(void(^)(NSString *,NSString *, NSString *))block;

@end


