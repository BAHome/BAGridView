//
//  BAFlowLayout.m
//  BAGridView_Example
//
//  Created by 博爱 on 2020/11/16.
//  Copyright © 2020 boai. All rights reserved.
//

#import "BAFlowLayout.h"

@interface BAFlowLayout ()

// 存放全部item布局信息的数组
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;

// 行数
@property (nonatomic, assign) NSInteger rowCount;
// item每行个数
@property (nonatomic, assign) NSInteger itemCountPerRow;
// item总数
@property (nonatomic, assign) NSInteger itemCountTotal;
// 页数
@property (nonatomic, assign) NSInteger pageCount;
// 最大行数
@property (nonatomic, assign) NSInteger maxRowCount;

@end


@implementation BAFlowLayout

- (instancetype)initWithItemCountPerRow:(NSInteger)itemCountPerRow maxRowCount:(NSInteger)maxRowCount {
    self = [super init];
    if (self) {
        self.attributesArray = [NSMutableArray array];
        self.itemCountPerRow = itemCountPerRow;
        self.maxRowCount     = maxRowCount;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemCountTotal = [self.collectionView numberOfItemsInSection:0];
    
    // rowCount
    if (self.itemCountTotal == 0) {
        self.rowCount = 0;
    } else if ((ceilf(self.itemCountTotal / (float)self.itemCountPerRow)) > self.maxRowCount) {
        self.rowCount = self.maxRowCount;
    } else {
        self.rowCount = ceilf(self.itemCountTotal / (float)self.itemCountPerRow);
    }
    
    self.pageCount = self.itemCountTotal ? ceilf(self.itemCountTotal / (float)(self.itemCountPerRow * self.maxRowCount)) : 0;
    
    // 需预先清除 self.attributesArray 数组
    if (self.attributesArray.count > 0) {
        [self.attributesArray removeAllObjects];
    }
    for (NSInteger i = 0; i < self.itemCountTotal; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = indexPath.item;

    /*
     0 2 4 ---\  0 1 2
     1 3 5 ---/  3 4 5 计算转换后对应的item  原来'4'的item为4,转换后为3
     */
    NSInteger page = item / (self.itemCountPerRow * self.maxRowCount);
    // 计算目标item的位置 x 横向偏移  y 竖向偏移
    NSUInteger x = item % self.itemCountPerRow + page * self.itemCountPerRow;
    NSUInteger y = item / self.itemCountPerRow - page * self.rowCount;
    // 根据偏移量计算item
    NSInteger newItem = x * self.rowCount + y;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newItem inSection:indexPath.section];

    UICollectionViewLayoutAttributes *newAttributes = [super layoutAttributesForItemAtIndexPath:newIndexPath];
    newAttributes.indexPath = indexPath;

    return newAttributes;
}

- (CGSize)collectionViewContentSize {
    if (!self.itemCountTotal) return CGSizeMake(0, 0);
    
    return CGSizeMake(self.pageCount * CGRectGetWidth(self.collectionView.frame), 0);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *array = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attr1 in attributes) {
        for (UICollectionViewLayoutAttributes *attr2 in self.attributesArray) {
            if (attr1.indexPath.item == attr2.indexPath.item) {
                [array addObject:attr2];
                break;
            }
        }
    }
    return array;
}

@end
