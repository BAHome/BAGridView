//
//  BATestView.m
//  BAGridView_Example
//
//  Created by 博爱 on 2020/11/16.
//  Copyright © 2020 boai. All rights reserved.
//

#import "BATestView.h"
#import "BAKit_BAGridView.h"
#import "BAGridViewFlyHorizontalFlowLauyout.h"

#import "Masonry.h"

@interface BATangramMenuSubCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UILabel *label;

@end


@implementation BATangramMenuSubCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:12.f];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(12);
    }];
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _label.text = title;
}

@end

@interface BATestView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BATestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self initData];
    }
    return self;
}

- (void)initUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    BAGridViewFlyHorizontalFlowLauyout *layout = BAGridViewFlyHorizontalFlowLauyout.new;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
//    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGFloat itemWidth = BAKit_SCREEN_WIDTH / 4;
    layout.itemSize = CGSizeMake(itemWidth, 100);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    
    [_collectionView registerClass:[BATangramMenuSubCell class] forCellWithReuseIdentifier:[BATangramMenuSubCell description]];
    [self addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}

- (void)initData {
    
}

#pragma mark - UICollectionViewDelegate，UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATangramMenuSubCell *subCell = [collectionView dequeueReusableCellWithReuseIdentifier:[BATangramMenuSubCell description] forIndexPath:indexPath];
    subCell.title = @(indexPath.row).stringValue;
    subCell.backgroundColor = BAKit_Color_RandomRGB_pod();
    
    return subCell;
}



@end
