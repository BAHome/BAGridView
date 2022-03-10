//
//  BAGridViewTypeTitleDescCell.m
//  BAKit
//
//  Created by boai on 2017/4/14.
//  Copyright © 2017年 boaihome. All rights reserved.
//

#import "BAGridViewTypeTitleDescCell.h"
#import "BAGridItemModel.h"
#import "BAKit_ConfigurationDefine.h"
#import "BAGridView_Config.h"


#pragma mark - 根据文字内容、高度和字体返回 宽度
CG_INLINE CGFloat
BAKit_LabelWidthWithTextAndFont(NSString *text, CGFloat height, UIFont *font){
    CGSize size = CGSizeMake(MAXFLOAT, height);
    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil];
    
    return frame.size.width;
}

#pragma mark - 根据 NSAttributedString 文字内容、高度和字体返回 宽度
CG_INLINE CGFloat
BAKit_LabelWidthWithNSAttributedTextAndFont(NSAttributedString *text, CGFloat height, UIFont *font){
    CGSize size = CGSizeMake(MAXFLOAT, height);
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return frame.size.width;
}

@interface BAGridViewTypeTitleDescCell ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descLabel;

@property(nonatomic, strong) UIView *lineView_w;
@property(nonatomic, strong) UIView *lineView_h;

@property(nonatomic, strong) UIButton *badgeButton;

@end

@implementation BAGridViewTypeTitleDescCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.titleLabel.hidden = NO;
    self.descLabel.hidden = NO;
    self.badgeButton.hidden = YES;

    self.lineView_w.backgroundColor = BAKit_Color_Gray_11_pod;
    self.lineView_h.backgroundColor = BAKit_Color_Gray_11_pod;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_descLabel];
    [self.contentView addSubview:_lineView_w];
    [self.contentView addSubview:_lineView_h];
    [self.contentView addSubview:self.badgeButton];
//    self.contentView.backgroundColor = BAKit_Color_RandomRGB_pod();
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat view_w = self.bounds.size.width;
    CGFloat view_h = self.bounds.size.height;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat max_w = view_w - self.config.ba_gridView_lineWidth;
    
    min_h = view_h * 0.4;
    if (self.config.model.titleAttributedString.length > 0) {
        min_w = BAKit_LabelWidthWithNSAttributedTextAndFont(self.config.model.titleAttributedString, min_h, self.titleLabel.font) + self.config.ba_gridView_titleWidthOffset;
    } else {
        min_w = BAKit_LabelWidthWithTextAndFont(self.titleLabel.text, min_h, self.titleLabel.font) + self.config.ba_gridView_titleWidthOffset;
    }
    min_w = min_w > max_w ? max_w:min_w;
    min_y = CGRectGetMidY(self.bounds) - min_h / 2 - view_h * 0.15;
    min_x = max_w/2.0 - min_w/2.0;
    self.titleLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = CGRectGetMaxY(self.titleLabel.frame) + self.config.ba_gridView_itemImageInset;
    min_h = view_h * 0.3;
    min_w = max_w;
    self.descLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    
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
    
    if (self.config.model.badge.length > 0) {
        self.badgeButton.hidden = NO;
        min_h = self.config.ba_gridView_badgeHeight;
        UIFont *font = (self.config.ba_gridView_badgeFont) ? self.config.ba_gridView_badgeFont : self.badgeButton.titleLabel.font;
        CGPoint offsetPoint = self.config.ba_gridView_badgeOffsetPoint;
        min_w = BAKit_LabelWidthWithTextAndFont(self.badgeButton.titleLabel.text, min_h, font) + 5;
        min_w = min_w < min_h ? min_h:min_w;
        if (self.config.ba_gridView_badgeType == kBAGridViewBadgeType_Center) {
            min_x = view_w - (view_w - CGRectGetWidth(self.titleLabel.frame))/2.0 - min_w/2.0;
        } else {
            min_x = CGRectGetMaxX(self.titleLabel.frame) + min_h/2.0 - min_w;
        }
        min_y = CGRectGetMinY(self.titleLabel.frame) - min_h/2.0;
        self.badgeButton.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
        CGPoint newPoint = self.badgeButton.center;
        newPoint.x += offsetPoint.x;
        newPoint.y += offsetPoint.y;
        self.badgeButton.center = newPoint;
        
        [self addCornerWithView:self.badgeButton byRoundingCorners:self.config.ba_gridView_badgeRectCorners cornerRadii:CGSizeMake(self.config.ba_gridView_badgeCornerRadius, self.config.ba_gridView_badgeCornerRadius)];
        
    } else {
        self.badgeButton.hidden = YES;
    }
}

- (void)addCornerWithView:(UIView *)view
        byRoundingCorners:(UIRectCorner)corners
              cornerRadii:(CGSize)cornerRadii {
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.frame = view.bounds;
    
    view.layer.mask = shapeLayer;
    view.clipsToBounds = YES;
}

#pragma mark - setter / getter

- (void)setConfig:(BAGridView_Config *)config {
    _config = config;
    
    if (config.model.titleAttributedString.length > 0) {
        self.titleLabel.attributedText = config.model.titleAttributedString;
    } else {
        self.titleLabel.text = config.model.titleString;
        self.titleLabel.font = config.ba_gridView_titleFont;
        self.titleLabel.textColor = config.ba_gridView_titleColor;
    }
    
    if (config.model.badge.length > 0) {
        self.badgeButton.hidden = NO;
        
        [self.badgeButton setTitle:config.model.badge forState:UIControlStateNormal];
        //            [self.badgeButton setTitle:@"99+" forState:UIControlStateNormal];
        self.badgeButton.titleLabel.font = config.ba_gridView_badgeFont;
        self.badgeButton.backgroundColor = config.ba_gridView_badgeBgColor;
        [self.badgeButton setTitleColor:config.ba_gridView_badgeTextColor forState:UIControlStateNormal];
    } else {
        self.badgeButton.hidden = YES;
        [self.badgeButton setTitle:@"" forState:UIControlStateNormal];
        self.badgeButton.backgroundColor = UIColor.clearColor;
    }
    
    if (config.model.descAttributedString.length > 0) {
        self.descLabel.attributedText = config.model.descAttributedString;
    } else {
        self.descLabel.text = config.model.desc;
        self.descLabel.font = config.ba_gridView_titleDescFont;
        self.descLabel.textColor = config.ba_gridView_titleDescColor;
    }
    
    self.lineView_h.backgroundColor = config.ba_gridView_lineColor;
    self.lineView_w.backgroundColor = config.ba_gridView_lineColor;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:25];
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        self.descLabel.font = [UIFont systemFontOfSize:12];
    }
    return _descLabel;
}

- (UIView *)lineView_w {
    if (!_lineView_w) {
        _lineView_w = [UIView new];
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

@end
