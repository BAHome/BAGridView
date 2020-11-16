//
//  BAGridView_Config.h
//  BAGridView
//
//  Created by 丁寅初 on 2018/1/11.
//  Copyright © 2018年 boai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BAKit_ConfigurationDefine.h"
#import "BAGridItemModel.h"

@class BAGridItemModel;

/**
 宫格样式
 
 - BAGridViewTypeImageTitle: 图上文下
 - BAGridViewTypeTitleImage: 文上图下
 - BAGridViewTypeBgImageTitle: 带背景图片，中间是文字
 - BAGridViewTypeTitleDesc: 上下都是文字，上面标题字体大，下面是详情字体小
 */
typedef NS_ENUM(NSUInteger, BAGridViewType) {
    BAGridViewTypeImageTitle = 0,
    BAGridViewTypeTitleImage,
    BAGridViewTypeBgImageTitle,
    BAGridViewTypeTitleDesc
};

typedef NS_ENUM(NSUInteger, BAGridViewBadgeType) {
    // 默认：和 iPhone 桌面 APP 默认角标处理一致，角标的 centerY 和右边距离图片右边为高度的一半，宽度往左边伸展
    kBAGridViewBadgeType_Default = 0,
    // 角标的圆心为图片的右上角，宽高向两边伸展
    kBAGridViewBadgeType_Center,
};

/**
 BAGridView 回调
 
 @param model 返回 BAGridItemModel
 @param indexPath indexPath
 */
typedef void (^BAGridViewBlock)(BAGridItemModel *model, NSIndexPath *indexPath);

@interface BAGridView_Config : NSObject


/**
 是否可以滑动，默认：YES
 */
@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;

/**
 宫格样式，默认：BAGridViewTypeImageTitle
 */
@property(nonatomic, assign) BAGridViewType gridViewType;

/**
 item：高度，图片高度 默认：ba_gridView_itemHeight * 0.4
 */
@property(nonatomic, assign) CGFloat ba_gridView_itemHeight;

/**
 item：宽度，图片高度 默认：如果不设置，为自适应宽度（BAGridView 宽度 - ba_gridView_itemHeight * count）/ count
 */
@property(nonatomic, assign) CGFloat ba_gridView_itemWidth;

/**
 item：layout 的 UIEdgeInsets，默认：UIEdgeInsetsMake(0, 0, 0, 0)
 */
@property(nonatomic) UIEdgeInsets ba_gridView_itemEdgeInsets;

/**
 item：layout 的 minimumLineSpacing，默认：0
 */
@property(nonatomic, assign) CGFloat minimumLineSpacing;

/**
 item：layout 的 minimumLineSpacing，默认：0
 */
@property(nonatomic, assign) CGFloat minimumInteritemSpacing;

/**
 item：图片与文字间距（或者两行文字类型的间距），默认：0
 */
@property(nonatomic, assign) CGFloat ba_gridView_itemImageInset;

/**
 item：每行 item 的个数，默认：4个
 */
@property(nonatomic, assign) NSInteger ba_gridView_rowCount;

/**
 item：title 颜色，默认：BAKit_Color_Black【[UIColor blackColor]】
 */
@property(nonatomic, strong) UIColor *ba_gridView_titleColor;

/**
 item：Desc 颜色，默认：BAKit_Color_Gray_9【BAKit_Color_RGB(216, 220, 228)】
 */
@property(nonatomic, strong) UIColor *ba_gridView_titleDescColor;

/**
 item：分割线颜色，默认：BAKit_Color_Gray_10【BAKit_Color_RGB(240, 240, 240)】
 */
@property(nonatomic, strong) UIColor *ba_gridView_lineColor;

/**
 item：背景颜色，默认：BAKit_Color_White
 */
@property(nonatomic, strong) UIColor *ba_gridView_backgroundColor;

/**
 item：背景选中颜色，默认：无色
 */
@property(nonatomic, strong) UIColor *ba_gridView_selectedBackgroundColor;

/**
 item：是否显示分割线
 */
@property(nonatomic, assign, getter=isShowLineView) BOOL showLineView;

/**
 item：title Font，默认：图文样式下 16，两行文字下（上25，下12）
 */
@property(nonatomic, strong) UIFont *ba_gridView_titleFont;

/**
 item：Desc Font，默认：两行文字下 12
 */
@property(nonatomic, strong) UIFont *ba_gridView_titleDescFont;

/**
 数据源：来自 BAGridItemModel
 */
@property(nonatomic, strong) NSArray <BAGridItemModel *>*dataArray;

/**
 cell数据源：来自 BAGridItemModel
 */
@property(nonatomic, strong) BAGridItemModel *model;

/**
 item：点击回调
 */
@property(nonatomic, copy)   BAGridViewBlock ba_gridViewBlock;
@property(nonatomic, assign) CGFloat ba_gridView_lineWidth;

#pragma mark - 2019-10-09 新增
/**
 图片宽度
 */
@property(nonatomic, assign) CGFloat ba_gridView_imageWidth;

/**
图片高度
*/
@property(nonatomic, assign) CGFloat ba_gridView_imageHeight;


#pragma mark - 2020-03-13 新增 badge

/**
badge：badge Type，默认：见 BAGridViewBadgeType 注释
*/
@property(nonatomic, assign) BAGridViewBadgeType ba_gridView_badgeType;

/**
badge：badge Font，默认：系统字体 12
*/
@property(nonatomic, strong) UIFont *ba_gridView_badgeFont;

/**
badge：badge BgColor，默认：红色
*/
@property(nonatomic, strong) UIColor *ba_gridView_badgeBgColor;

/**
badge：badge TextColor，默认：白色
*/
@property(nonatomic, strong) UIColor *ba_gridView_badgeTextColor;

/**
badge：badge Height，默认：20
*/
@property(nonatomic, assign) CGFloat ba_gridView_badgeHeight;

/**
badge：badge Offset，默认：0,0，正值：往右往上，负值：往左往下
*/
@property(nonatomic, assign) CGPoint ba_gridView_badgeOffsetPoint;

/**
badge：badge RectCorners，默认：所有角度 UIRectCornerAllCorners
*/
@property(nonatomic, assign) UIRectCorner ba_gridView_badgeRectCorners;

/**
badge：badge CornerRadius，默认：高度/2.0
*/
@property(nonatomic, assign) CGFloat ba_gridView_badgeCornerRadius;

#pragma mark - 2020-04-08 新增 图片圆角
/**
image：image CornerRadius，默认：0
*/
@property(nonatomic, assign) CGFloat ba_gridView_ImageCornerRadius;

#pragma mark - 2020-04-15 新增 图片填充样式
/**
image：image contentMode，默认：UIViewContentModeScaleToFill
*/
@property(nonatomic, assign) UIViewContentMode ba_gridView_ImageContentMode;

#pragma mark - 2020-07-30 新增 背景图片填充样式
/**
bgImage：bgiimage contentMode，默认：UIViewContentModeScaleToFill
*/
@property(nonatomic, assign) UIViewContentMode ba_gridView_bgImageContentMode;

#pragma mark - 2020-11-16 新增 横向滚动 样式
/**
排列方式：是否是
 0 2 4 6 8 || 10 12 14 16 18
 1 3 5 7 9 || 11 13 15 17 19
 这样排列，
 系统默认横向滚动排列是：
 01234 || 10 11 12 13 14
 56789 || 15 16 17 18 19
*/
@property(nonatomic, assign) BOOL isFlyHorizontalFlowLauyout;

/**
 UIScrollView 的滚动代理
 */
@property(nonatomic, copy) void (^onGridScrollViewDidScroll)(UIScrollView *scrollView);

@end
