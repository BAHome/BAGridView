//
//  BAFlowLayout.h
//  BAGridView_Example
//
//  Created by 博爱 on 2020/11/16.
//  Copyright © 2020 boai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BAFlowLayout : UICollectionViewFlowLayout

- (instancetype)initWithItemCountPerRow:(NSInteger)itemCountPerRow
                            maxRowCount:(NSInteger)maxRowCount;

@end

NS_ASSUME_NONNULL_END
