//
//  BAFlowLayout1.h
//  BAGridView_Example
//
//  Created by 博爱 on 2020/11/16.
//  Copyright © 2020 boai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BAFlowLayout1 : UICollectionViewFlowLayout

@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;

@end

NS_ASSUME_NONNULL_END
