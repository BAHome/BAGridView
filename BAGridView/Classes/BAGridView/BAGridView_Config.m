//
//  BAGridView_Config.m
//  BAGridView
//
//  Created by 丁寅初 on 2018/1/11.
//  Copyright © 2018年 boai. All rights reserved.
//

#import "BAGridView_Config.h"

@implementation BAGridView_Config
- (instancetype)init {
    if (self == [super init]) {
        
        // 默认配置
        self.gridViewType = BAGridViewTypeTitleDesc;
        self.ba_gridView_rowCount = 4;
        self.ba_gridView_lineColor = BAKit_Color_Gray_10_pod;
        self.ba_gridView_titleColor = BAKit_Color_Black_pod;
        self.ba_gridView_titleDescColor = BAKit_Color_Gray_9_pod;
        self.ba_gridView_itemImageInset = 0;
        self.ba_gridView_backgroundColor = BAKit_Color_White_pod;
        self.dataArray = @[].mutableCopy;
        self.ba_gridView_lineWidth = BAKit_Flat_pod(0.5f);
        self.scrollEnabled = YES;
        
        self.ba_gridView_badgeType = kBAGridViewBadgeType_Default;
        self.ba_gridView_badgeBgColor = UIColor.redColor;
        self.ba_gridView_badgeTextColor = UIColor.whiteColor;
        self.ba_gridView_badgeHeight = 20;
        self.ba_gridView_badgeRectCorners = UIRectCornerAllCorners;
        self.ba_gridView_badgeCornerRadius = self.ba_gridView_badgeHeight/2.0;
    }
    return self;
}

@end
