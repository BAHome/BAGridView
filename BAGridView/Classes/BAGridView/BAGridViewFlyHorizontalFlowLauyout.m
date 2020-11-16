//
//  BAGridViewFlyHorizontalFlowLauyout.m
//  BAGridView
//
//  Created by 博爱 on 2020/11/16.
//

#import "BAGridViewFlyHorizontalFlowLauyout.h"

@interface BAGridViewFlyHorizontalFlowLauyout()

@property (strong, nonatomic) NSMutableArray *allAttributes;
//每个section的页码的总数
@property (strong, nonatomic) NSMutableDictionary *sectionPageDictionary;

@end

@implementation BAGridViewFlyHorizontalFlowLauyout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.sectionPageDictionary = [NSMutableDictionary dictionary];
    self.allAttributes = [NSMutableArray array];
    
    //获取section的数量
    NSUInteger section = [self.collectionView numberOfSections];
    
    for (NSUInteger sectionIndex = 0; sectionIndex < section; sectionIndex++) {
        //获取每个section的cell个数
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        
        for (NSUInteger item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:sectionIndex];
            //重新排列
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.allAttributes addObject:attributes];
            
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    [self updateItemLayoutAttributes:attributes];
    return attributes;
}
#warning 还有一个问题需要考虑 当cell的宽度+sectionInsets.left + sectionInsets.right 大于 collectionView 的宽度的时候 或者cell的高度+sectionInsets.top + sectionInsets.bottom 大于collectionView的高度时 会崩溃 崩溃在计算当前页的地方
- (void)updateItemLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
    if(attributes.representedElementKind != nil) {
        return;
    }
    //获取attributes对应的section
    NSInteger section = attributes.indexPath.section;
    //获取attributes的下标值 从0开始
    NSInteger itemIndex = attributes.indexPath.item;
    //获取当前section的item的个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    
    //获取当前section的inset
    UIEdgeInsets sectionInsets = [self evaluatedInsetForSectionAtIndex:section];
    //获取当前section item之前的最小间隔
    CGFloat minimumInteritemSpacing = [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
    //获取当前section 分割线的最小高度
    CGFloat minimumLineSpacing = [self evaluatedMinimumLineSpacingForSectionAtIndex:section];
    
    //当前item 的宽度
    CGFloat itemWidth = attributes.frame.size.width;
    //当前item 的高度
    CGFloat itemHeight = attributes.frame.size.height;
    
    //collectionView 的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    //collectionView 的高度
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    
    //1.初步计算水平方向上item的列数
    NSUInteger xItemCount = (collectionViewWidth - sectionInsets.left - sectionInsets.right)/itemWidth;
    //2.在水平方向上 如果所有item的宽度 加上左右内距 在加上 item之前的间隔 大于 collectionView的宽度 xItemCount - 1，因为item之间的间隔要远小于item的宽度
    if((xItemCount * itemWidth + sectionInsets.left + sectionInsets.right + (xItemCount - 1)*minimumInteritemSpacing) > collectionViewWidth) {
        xItemCount -=1;
        if(xItemCount == 0)//保证每页至少显示一个
        {
            xItemCount = 1;
        }
    }
    //重新计算水平方向上item之间的间隔 不做原生的那种自动排列 这里最好保证cell的宽度和cell之间的间隔是计算好的
    if(xItemCount > 1) {
        minimumInteritemSpacing = (collectionViewWidth - sectionInsets.left - sectionInsets.right - xItemCount*itemWidth)/(xItemCount - 1);
    }
    
    //同样计算垂直方向上的可显示item的行数
    NSInteger yItemCount = ((collectionViewHeight - sectionInsets.top - sectionInsets.bottom)/ itemHeight);
    if((yItemCount*itemHeight + sectionInsets.top + sectionInsets.bottom) + (yItemCount - 1)*minimumLineSpacing > collectionViewHeight) {
        yItemCount -= 1;
    }
    //重新计算垂直方向上item之间的间隔
    if(yItemCount > 1) {
        minimumLineSpacing = (collectionViewHeight - sectionInsets.top - sectionInsets.bottom - yItemCount*itemHeight)/(yItemCount - 1);
    }
    
    //计算一页总个数
    NSInteger eachPageItemCount = (xItemCount * yItemCount);
    
    //获取当前section的item对应的页数，从0开始
    NSInteger currentPage = itemIndex/eachPageItemCount;
    
    //余数，用来计算item的水平方向的偏移量
    NSInteger remain = (itemIndex % xItemCount) ;
    
    //x方向每个item的偏移量
    CGFloat xCellOffset = 0;
    if(remain == 0) {
        //每行的第一个 + sectionInsets.left
        xCellOffset = remain * itemWidth + sectionInsets.left;
    } else {
        //其他 + sectionInsets.left + remain*minimumInteritemSpacing + sectionInsets.left
        
        xCellOffset = remain * itemWidth + remain*minimumInteritemSpacing + sectionInsets.left;
    }
    
    //取商，用来计算item的垂直方向的偏移量
    NSInteger merchant = (itemIndex - currentPage * eachPageItemCount)/xItemCount;
    //垂直方向每个item的偏移量 计算方式同水平方向的
    CGFloat yCellOffset = 0;
    if(merchant == 0) {
        yCellOffset = merchant * itemHeight + sectionInsets.top;
    } else {
        yCellOffset = merchant * itemHeight + merchant*minimumLineSpacing + sectionInsets.top;
    }
    
    //计算每个section中item占了几页
    NSInteger eachSectionPageCount = (itemCount % eachPageItemCount == 0)? (itemCount / eachPageItemCount) : (itemCount / eachPageItemCount) + 1;
    //将每个section与eachSectionPageCount对应，计算下面的位置，还要用来设置collectionView 的 contentSize
    [self.sectionPageDictionary setValue:@(eachSectionPageCount) forKey:[NSString stringWithFormat:@"%ld", section]];
    
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        //所有section的page总和
        NSInteger allSectionPage = 0;
        for (NSString *key in [self.sectionPageDictionary allKeys])
        {
            allSectionPage += [self.sectionPageDictionary[key] integerValue];
        }
        
        //获取到的最后的数减去最后一组的页码数
        allSectionPage -= [self.sectionPageDictionary[[NSString stringWithFormat:@"%ld", [self.sectionPageDictionary allKeys].count-1]] integerValue];
        //实现cell的翻页显示
        xCellOffset += collectionViewWidth*(allSectionPage + currentPage);
        
    } else {
        yCellOffset += section * collectionViewHeight;
    }
    attributes.frame = CGRectMake(xCellOffset, yCellOffset, itemWidth, itemHeight);
}


- (CGSize)collectionViewContentSize {
    //所有section的page总和
    NSInteger allSectionPage = 0;
    
    for (NSString *key in [self.sectionPageDictionary allKeys])
    {
        allSectionPage += [self.sectionPageDictionary[key] integerValue];
    }
    
    return CGSizeMake(allSectionPage*self.collectionView.frame.size.width, self.collectionView.contentSize.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.allAttributes;
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (CGFloat)evaluatedMinimumLineSpacingForSectionAtIndex:(NSInteger)sectionIndex {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumLineSpacing;
    }
}

- (UIEdgeInsets)evaluatedInsetForSectionAtIndex:(NSInteger)sectionIndex {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:sectionIndex];
    } else {
        return self.sectionInset;
    }
}

@end

