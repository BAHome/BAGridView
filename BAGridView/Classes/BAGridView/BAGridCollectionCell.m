//
//  BAGridCollectionCell.m
//  BAKit
//
//  Created by boai on 2017/4/14.
//  Copyright © 2017年 boaihome. All rights reserved.
//

#import "BAGridCollectionCell.h"
#import "BAGridItemModel.h"
#import "BAKit_ConfigurationDefine.h"

#import "NSString+BAGridView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BAGridView_Config.h"

#pragma mark - 根据文字内容、宽度和字体返回 size
CG_INLINE CGSize
BAKit_LabelSizeWithTextAndWidthAndFont(NSString *text, CGFloat width, UIFont *font){
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = [text boundingRectWithSize:size
                                      options:
                    NSStringDrawingTruncatesLastVisibleLine |
                    NSStringDrawingUsesLineFragmentOrigin |
                    NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : style} context:nil];
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    return newFrame.size;
}

#pragma mark - 根据文字内容、高度和字体返回 宽度
CG_INLINE CGFloat
BAKit_LabelWidthWithTextAndFont(NSString *text, CGFloat height, UIFont *font){
    CGSize size = CGSizeMake(MAXFLOAT, height);
    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil];
    
    return frame.size.width;
}

@interface BAGridCollectionCell ()

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIView *lineView_w;
@property(nonatomic, strong) UIView *lineView_h;

@property(nonatomic, strong) UIButton *badgeButton;

@end

@implementation BAGridCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.imageView];
    [self.bgImageView addSubview:self.lineView_w];
    [self.bgImageView addSubview:self.lineView_h];
    [self.bgImageView addSubview:self.badgeButton];
    
    
    //    self.bgImageView.hidden = NO;
    //    self.imageView.hidden = NO;
    //    self.titleLabel.hidden = NO;
    //    self.badgeButton.hidden = NO;
    
    self.lineView_w.backgroundColor = BAKit_Color_Gray_11_pod;
    self.lineView_h.backgroundColor = BAKit_Color_Gray_11_pod;
}

- (void)layoutView {
    CGFloat view_w = self.bounds.size.width;
    CGFloat view_h = self.bounds.size.height;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    
    min_x = 0;
    min_y = 0;
    min_w = view_h;
    min_h = min_w;
    self.bgImageView.frame = self.bounds;
    
    if (self.config.gridViewType == BAGridViewTypeImageTitle) {
        
        min_w = (self.config.ba_gridView_imageWidth > 0) ? self.config.ba_gridView_imageWidth : view_h * 0.4;
        min_h = (self.config.ba_gridView_imageHeight > 0) ? self.config.ba_gridView_imageHeight : min_w;
        
        min_x = (view_w - min_w) / 2;
        min_y = CGRectGetMidY(self.bounds) - min_h / 2 - view_h * 0.15;
        self.imageView.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
        if (self.config.model.badge.length > 0) {
            self.badgeButton.hidden = NO;
            min_h = self.config.ba_gridView_badgeHeight;
            UIFont *font = (self.config.ba_gridView_badgeFont) ? self.config.ba_gridView_badgeFont : self.badgeButton.titleLabel.font;
            CGPoint offsetPoint = self.config.ba_gridView_badgeOffsetPoint;
            min_w = BAKit_LabelWidthWithTextAndFont(self.badgeButton.titleLabel.text, min_h, font) + 5;
            min_w = min_w < min_h ? min_h:min_w;
            if (self.config.ba_gridView_badgeType == kBAGridViewBadgeType_Center) {
                min_x = view_w - (view_w - CGRectGetWidth(self.imageView.frame))/2.0 - min_w/2.0;
            } else {
                min_x = CGRectGetMaxX(self.imageView.frame) + min_h/2.0 - min_w;
            }
            min_y = CGRectGetMinY(self.imageView.frame) - min_h/2.0;
            self.badgeButton.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
            
            CGPoint newPoint = self.badgeButton.center;
            newPoint.x += offsetPoint.x;
            newPoint.y += offsetPoint.y;
            self.badgeButton.center = newPoint;
            
            [self addCornerWithView:self.badgeButton byRoundingCorners:self.config.ba_gridView_badgeRectCorners cornerRadii:CGSizeMake(self.config.ba_gridView_badgeCornerRadius, self.config.ba_gridView_badgeCornerRadius)];
            
        } else {
            self.badgeButton.hidden = YES;
        }
        
        min_x = 0;
        min_y = CGRectGetMaxY(self.imageView.frame) + self.config.ba_gridView_itemImageInset;
        min_w = view_w - self.config.ba_gridView_lineWidth;
        min_h = view_h - min_y;
        self.titleLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
        if (self.config.ba_gridView_ImageCornerRadius > 0) {
            [self addCornerWithView:self.imageView byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.config.ba_gridView_ImageCornerRadius, self.config.ba_gridView_ImageCornerRadius)];
        }
    } else if (self.config.gridViewType == BAGridViewTypeTitleImage) {
        
        min_w = (self.config.ba_gridView_imageWidth > 0) ? self.config.ba_gridView_imageWidth : view_h * 0.4;
        min_h = (self.config.ba_gridView_imageHeight > 0) ? self.config.ba_gridView_imageHeight : min_w;
        
        min_x = (view_w - min_w) / 2;
        min_y = CGRectGetMidY(self.bounds) - min_h / 2 + view_h * 0.15;
        self.imageView.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
        min_x = 0;
        min_w = view_w - self.config.ba_gridView_lineWidth;
        min_h = BAKit_LabelSizeWithTextAndWidthAndFont(self.config.model.titleString, min_w, self.config.ba_gridView_titleFont).height+3;
        min_y = CGRectGetMinY(self.imageView.frame) - min_h - self.config.ba_gridView_itemImageInset;
        if (min_y < 0) {
            min_y = 0;
        }
        self.titleLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
    } else if (self.config.gridViewType == BAGridViewTypeBgImageTitle) {
        min_x = 0;
        min_w = view_w;
        min_h = BAKit_LabelSizeWithTextAndWidthAndFont(self.config.model.titleString, min_w, self.config.ba_gridView_titleFont).height+3;
        min_y = CGRectGetMidY(self.bounds) - min_h / 2;
        self.titleLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
    }
    
    min_x = view_w - self.config.ba_gridView_lineWidth;
    min_y = 0;
    min_w = self.config.ba_gridView_lineWidth;
    min_h = view_h;
    self.lineView_h.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = view_h - self.config.ba_gridView_lineWidth;
    min_w = view_w;
    min_h = self.config.ba_gridView_lineWidth;
    self.lineView_w.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    
}

- (void)addCornerWithView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = view.bounds;
    
    view.layer.mask = shapeLayer;
    view.clipsToBounds = YES;
    
}

#pragma mark - setter / getter


- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.backgroundColor = BAKit_Color_Clear_pod;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = BAKit_Color_Clear_pod;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)lineView_w {
    if (!_lineView_w) {
        _lineView_w = [UIView new];
        [_bgImageView addSubview:_lineView_w];
    }
    return _lineView_w;
}

- (UIView *)lineView_h {
    if (!_lineView_h) {
        _lineView_h = [UIView new];
    }
    return _lineView_h;
}

- (UIButton *)badgeButton {
    if (!_badgeButton) {
        _badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_badgeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _badgeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _badgeButton.backgroundColor = UIColor.redColor;
    }
    return _badgeButton;
}

- (void)setPlacdholderImage:(UIImage *)placdholderImage {
    _placdholderImage = placdholderImage;
}

- (void)setConfig:(BAGridView_Config *)config {
    _config = config;
    
    if (self.config.gridViewType == BAGridViewTypeBgImageTitle) {
        if (config.model.bgImageName.length > 0 && [NSString ba_regularIsUrl:config.model.bgImageName]) {
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:config.model.bgImageName] placeholderImage:self.placdholderImage];
        } else {
            self.bgImageView.image = [UIImage imageNamed:config.model.bgImageName];
        }
    } else {
        if (config.model.imageName.length > 0 && [NSString ba_regularIsUrl:config.model.imageName]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:config.model.imageName] placeholderImage:self.placdholderImage];
        } else {
            self.imageView.image = [UIImage imageNamed:config.model.imageName];
        }
    }
    
    if (self.config.gridViewType == BAGridViewTypeImageTitle) {
        if (config.model.badge.length > 0) {
            [self.badgeButton setTitle:config.model.badge forState:UIControlStateNormal];
            //            [self.badgeButton setTitle:@"99+" forState:UIControlStateNormal];
            self.badgeButton.titleLabel.font = config.ba_gridView_badgeFont;
            self.badgeButton.backgroundColor = config.ba_gridView_badgeBgColor;
            [self.badgeButton setTitleColor:config.ba_gridView_badgeTextColor forState:UIControlStateNormal];
        }
    }
    
    self.titleLabel.text = config.model.titleString;
    self.titleLabel.font = config.ba_gridView_titleFont;
    self.titleLabel.textColor = config.ba_gridView_titleColor;
    
    self.lineView_h.backgroundColor = config.ba_gridView_lineColor;
    self.lineView_w.backgroundColor = config.ba_gridView_lineColor;
    
    [self layoutView];
}


@end
