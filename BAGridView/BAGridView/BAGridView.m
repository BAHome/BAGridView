//
//  BAGridView.m
//  BAKit
//
//  Created by boai on 2017/4/14.
//  Copyright © 2017年 boaihome. All rights reserved.
//

#import "BAGridView.h"
#import "BAGridCollectionCell.h"
#import "BAGridViewTypeTitleDescCell.h"

#import "BAGridView_Config.h"

static NSString * const kCellID = @"BAGridCollectionCell";
static NSString * const kCellID2 = @"BAGridViewTypeTitleDescCell";

@interface BAGridView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) BAGridView_Config *config;
@property(nonatomic, assign) CGFloat gridItem_w;
@property(nonatomic, weak) NSIndexPath  *selectIndexPath;


@end

@implementation BAGridView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
//        [self setupUI];
    }
    return self;
}

/**
 快速创建宫格
 
 @param config view 基础配置
 @param block 点击事件回调
 @return BAGridView
 */
+ (instancetype)ba_creatGridViewWithGridViewConfig:(BAGridView_Config *)config
                                             block:(BAGridViewBlock)block
{
    BAGridView *tempView = [[BAGridView alloc] init];
    
    if (config == nil) {
        config = [[BAGridView_Config alloc] init];
    }
    tempView.config = config;
    [tempView setupUI];
    return tempView;
}

- (void)setupUI
{
    self.backgroundColor = BAKit_Color_Clear_pod;
    self.collectionView.hidden = NO;
    self.backgroundColor = self.config.ba_gridView_backgroundColor;
    if (!self.config.showLineView)
    {
        self.config.ba_gridView_lineWidth = 0;
    }
    self.gridItem_w = (BAKit_SCREEN_WIDTH - (self.config.ba_gridView_rowCount - 1) * self.config.ba_gridView_lineWidth)/self.config.ba_gridView_rowCount;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.config.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BAGridCollectionCell *cell;
    BAGridViewTypeTitleDescCell *cell2;
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    self.config.model = self.config.dataArray[indexPath.row];
    if (self.config.gridViewType == BAGridViewTypeImageTitle ||
        self.config.gridViewType == BAGridViewTypeTitleImage ||
        self.config.gridViewType == BAGridViewTypeBgImageTitle
        )
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
        cell.backgroundColor = BAKit_Color_Clear_pod;
        cell.config = self.config;
        return cell;
    }
    else if (self.config.gridViewType == BAGridViewTypeTitleDesc)
    {
        cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID2 forIndexPath:indexPath];
        cell2.backgroundColor = BAKit_Color_Clear_pod;
        cell2.config = self.config;
        return cell2;
    }
    
    return [UICollectionViewCell new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =  [collectionView cellForItemAtIndexPath:indexPath];
    // 选中之后的cell变颜色
    [self ba_updateCell:cell indexPath:indexPath selected:YES];
    
    BAGridItemModel *model = self.config.dataArray[indexPath.row];

    if (self.config.ba_gridViewBlock)
    {
        self.config.ba_gridViewBlock(model, indexPath);
    }
}

// 取消选中操作
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    [self ba_updateCell:cell indexPath:indexPath selected:NO];
}

// 改变cell的背景颜色
- (void)ba_updateCell:(id)cell
            indexPath:(NSIndexPath *)indexPath
             selected:(BOOL)selected
{
    [UIView animateWithDuration:0.20f animations:^{
        ((UICollectionViewCell *)cell).backgroundColor = selected ? self.config.ba_gridView_selectedBackgroundColor : self.config.ba_gridView_backgroundColor;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f animations:^{
            ((UICollectionViewCell *)cell).backgroundColor = self.backgroundColor;
        }];
    }];

    self.selectIndexPath = indexPath;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSizeMake(self.gridItem_w, self.config.ba_gridView_itemHeight));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - setter / getter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = BAKit_Color_Clear_pod;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[BAGridCollectionCell class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[BAGridViewTypeTitleDescCell class] forCellWithReuseIdentifier:kCellID2];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


@end
