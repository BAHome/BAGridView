//
//  BAViewController.m
//  BAGridView
//
//  Created by boai on 2017/6/12.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "BAViewController.h"
#import "BAKit_BAGridView.h"
#import "BAGridView_Config.h"
#import "BATestView.h"

static NSString * const kCellID = @"ViewControllerCell";

#define kGridView_rowCount   4
//#define kGridView_itemWidth  100
#define kGridView_itemHeight 100
#define kGridView_H          BAKit_getColumnCountWithArrayAndRowCount_pod(self.gridDataArray, kGridView_rowCount) * kGridView_itemHeight + 50

#define kGridView_rowCount2   3
#define kGridView_itemHeight2 100
#define kGridView_H2          BAKit_getColumnCountWithArrayAndRowCount_pod(self.gridDataArray2, kGridView_rowCount2) * kGridView_itemHeight2

CG_INLINE NSInteger
BAKit_GetScrollViewCurrentPage(UIScrollView *scrollView) {
    if (scrollView.frame.size.width == 0 || scrollView.frame.size.height == 0) {
        return 0;
    }
    NSInteger index = 0;
    index = roundf((scrollView.contentOffset.x) / scrollView.frame.size.width);
    
    return MAX(0, index);
}

CG_INLINE NSInteger
BAKit_RandomNumber(NSInteger i){
    return arc4random() % i;
}

static NSString * const kUrl1 = @"http://fc.topitme.com/c/08/e1/11235427029dbe108cm.jpg";
static NSString * const kUrl2 = @"http://pic.58pic.com/58pic/12/68/14/87w58PIC3hU.jpg";

@interface BAViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) UIViewController *vc1;
@property(nonatomic, strong) UIViewController *vc2;

@property(nonatomic, strong) BAGridView *gridView;
@property(nonatomic, strong) BAGridView *gridView2;

@property(nonatomic, strong) NSMutableArray  <BAGridItemModel *> *gridDataArray;
@property(nonatomic, strong) NSMutableArray  <BAGridItemModel *> *gridDataArray2;

@property(nonatomic, assign) BOOL isSelectCell;
@property(nonatomic, strong) BAGridView_Config *ba_GridViewConfig;
@property(nonatomic, strong) BAGridView_Config *ba_GridViewConfig2;

@end

@implementation BAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    self.title = @"BAGridView";
    self.view.backgroundColor = BAKit_Color_White_pod;
    self.isSelectCell = NO;
    
    [self initNavi];
}

- (void)initNavi {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新数据" style:UIBarButtonItemStylePlain target:self action:@selector(handleNaviItem)];
}

- (void)handleNaviItem {
    if (self.ba_GridViewConfig2.gridViewType != BAGridViewTypeTitleDesc) {
        // 注意：此处的刷新，只做了 两行文字的刷新，其他类型的类似操作即可
        return;
    }
    
    BAGridView_Config *config = self.ba_GridViewConfig2;
    
    NSMutableArray *dataArray = @[].mutableCopy;
    
    NSInteger num = BAKit_RandomNumber(10);
    num = (num > 1) ? num : 1;
    
    for (NSInteger i = 0; i < num; ++i) {
        NSString *desc = [NSString stringWithFormat:@"标题（%ld）", num];
        
        BAGridItemModel *model = [BAGridItemModel new];
        model.titleString = @(num).stringValue;
        model.desc = desc;
        
        [dataArray addObject:model];
    }
    
    [self.gridDataArray2 removeAllObjects];
    self.gridDataArray2 = dataArray.mutableCopy;
    config.dataArray = self.gridDataArray2;
    
    // 如果高度要是可变的话，就把顶部 kGridView_itemHeight2 换成属性，重新调用 layoutSubviews 即可
    self.gridView2.config = config;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    
    NSString *msg = [@(indexPath.row + 1).stringValue stringByAppendingString:@"、"];
    cell.textLabel.text = [msg stringByAppendingString:self.dataArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.gridView = nil;
    self.gridDataArray = nil;
    
    switch (indexPath.row) {
        case 0: {
            self.isSelectCell = !self.isSelectCell;
            if (!self.isSelectCell) {
                self.ba_GridViewConfig.gridViewType = BAGridViewTypeTitleImage;
                cell.textLabel.text = @"1、图上文下(点击更换样式)";
            } else {
                self.ba_GridViewConfig.gridViewType = BAGridViewTypeImageTitle;
                cell.textLabel.text = @"1、文上图下(点击更换样式)";
            }
            
            self.tableView.tableFooterView = [UIView new];
            UIView *footView = [self.view viewWithTag:100];
            
            if (!footView) {
                footView = [UIView new];
                footView.backgroundColor = [UIColor redColor];
                footView.frame = CGRectMake(0, 20, BAKit_SCREEN_WIDTH, kGridView_H2);
                footView.tag = 100;
                self.gridView.frame = footView.bounds;
                [footView addSubview:self.gridView];
            }
            self.tableView.tableFooterView = footView;
        }
            break;
        case 1: {
            self.ba_GridViewConfig.gridViewType = BAGridViewTypeBgImageTitle;
            self.tableView.tableFooterView = [UIView new];
            
            UIView *footView = [self.view viewWithTag:101];
            
            if (!footView) {
                footView = [UIView new];
                footView.backgroundColor = [UIColor redColor];
                footView.frame = CGRectMake(0, 20, BAKit_SCREEN_WIDTH, kGridView_H2);
                footView.tag = 101;
                self.gridView.frame = footView.bounds;
                [footView addSubview:self.gridView];
            }
            self.tableView.tableFooterView = footView;
        }
            break;
        case 2: {
            self.ba_GridViewConfig2.gridViewType = BAGridViewTypeTitleDesc;
            self.ba_GridViewConfig2.isFlyHorizontalFlowLauyout = NO;
            
            self.tableView.tableFooterView = [UIView new];
            
            UIView *footView = [self.view viewWithTag:102];
            
            if (!footView) {
                footView = [UIView new];
                footView.backgroundColor = [UIColor redColor];
                footView.frame = CGRectMake(0, 20, BAKit_SCREEN_WIDTH, kGridView_H2);
                footView.tag = 102;
                self.gridView2.frame = CGRectMake(30, 0, BAKit_SCREEN_WIDTH - 30 * 2, kGridView_H2);
                [footView addSubview:self.gridView2];
            }
            
            self.tableView.tableFooterView = footView;
        }
            break;
        case 3: {
            self.ba_GridViewConfig2.gridViewType = BAGridViewTypeTitleDesc;
            self.ba_GridViewConfig2.isFlyHorizontalFlowLauyout = YES;
            
            self.tableView.tableFooterView = UIView.new;
            
            NSInteger tag = 103;
            UIView *footView = [self.view viewWithTag:tag];
            
            if (!footView) {
                //                BATestView *view = BATestView.new;
                //                view.frame = CGRectMake(30, 0, BAKit_SCREEN_WIDTH - 30 * 2, kGridView_itemHeight2 * 2);
                self.gridView2.frame = CGRectMake(30, 0, BAKit_SCREEN_WIDTH - 30 * 2, kGridView_itemHeight2 * 2);
                
                footView = UIView.new;
                footView.backgroundColor = [UIColor redColor];
                footView.frame = CGRectMake(0, 20, BAKit_SCREEN_WIDTH, kGridView_itemHeight2 * 2);
                footView.tag = tag;
                [footView addSubview:self.gridView2];
            }
            self.tableView.tableFooterView = footView;
        }
            break;
            
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    
}

#pragma mark - setter / getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = BAKit_Color_Gray_10_pod;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.tableView.tableFooterView = [UIView new];
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"图上文下 / 文上图下(点击更换样式)",
                       @"带背景图片，中间是文字",
                       @"两行文字",
                       @"自定义横向滚动排列【左右滑动试试】",
        ];
    }
    return _dataArray;
}

- (BAGridView_Config *)ba_GridViewConfig {
    if (!_ba_GridViewConfig) {
        _ba_GridViewConfig = [[BAGridView_Config alloc] init];
    }
    return _ba_GridViewConfig;
}

- (BAGridView_Config *)ba_GridViewConfig2 {
    if (!_ba_GridViewConfig2) {
        _ba_GridViewConfig2 = [[BAGridView_Config alloc] init];
    }
    return _ba_GridViewConfig2;
}

- (BAGridView *)gridView {
    if (!_gridView) {
        
        BAGridView_Config *config = self.ba_GridViewConfig;
        
        config.scrollEnabled = YES;
        // 是否显示分割线
        config.showLineView = YES;
        // item：分割线颜色，默认：BAKit_Color_Gray_11【BAKit_Color_RGB(248, 248, 248)】
        config.ba_gridView_lineColor = BAKit_Color_Red_pod;
        // item：每行 item 的个数，默认为4个
        config.ba_gridView_rowCount = kGridView_rowCount;
        // item：高度/宽度
        config.ba_gridView_itemHeight = kGridView_itemHeight;
        config.ba_gridView_imageWidth = 40;
        config.ba_gridView_imageHeight = 40;
        
        // item：图片与文字间距（或者两行文字类型的间距），默认：0
        config.ba_gridView_itemImageInset = 5;
        //  item：title 颜色，默认：BAKit_Color_Black【[UIColor blackColor]】
        //            config.ba_gridView_titleColor = BAKit_Color_Black;
        // item：title Font，默认：图文样式下 16，两行文字下（上25，下12）
        config.ba_gridView_titleFont = [UIFont boldSystemFontOfSize:15];
        // item：背景颜色，默认：BAKit_Color_White
        config.ba_gridView_backgroundColor = UIColor.yellowColor;
        // item：背景选中颜色，默认：无色
        config.ba_gridView_selectedBackgroundColor = BAKit_Color_Red_pod;
        // badge
        config.ba_gridView_badgeType = kBAGridViewBadgeType_Center;
        config.ba_gridView_badgeFont = [UIFont systemFontOfSize:10];
        config.ba_gridView_badgeRectCorners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight;
        //        config.ba_gridView_badgeCornerRadius = 3;
        //        config.ba_gridView_badgeBgColor = UIColor.orangeColor;
        //        config.ba_gridView_badgeTextColor = UIColor.greenColor;
        //        config.ba_gridView_badgeHeight = 30;
        //        config.ba_gridView_badgeOffsetPoint = CGPointMake(10, -10);
        
        // item：图片圆角
        config.ba_gridView_ImageCornerRadius = 20;
        config.ba_gridView_bgImageContentMode = UIViewContentModeScaleAspectFill;
        
        config.dataArray = self.gridDataArray;
        //        config.ba_gridView_itemEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        //        config.minimumLineSpacing = 10;
        //        config.minimumInteritemSpacing = 10;
        
        
        _gridView = [BAGridView ba_creatGridViewWithGridViewConfig:self.ba_GridViewConfig
                                                  placdholderImage:[UIImage imageNamed:@"icon_placeholder"]
                                                             block:^(BAGridItemModel *model, NSIndexPath *indexPath) {
            
            BAKit_ShowAlertWithMsg_ios8(model.titleString);
        }];
    }
    return _gridView;
}

- (BAGridView *)gridView2 {
    if (!_gridView2) {
        BAGridView_Config *config = self.ba_GridViewConfig2;
        
        config.showLineView = YES;
        config.isFlyHorizontalFlowLauyout = YES;
        // item：分割线颜色，默认：BAKit_Color_Gray_11【BAKit_Color_RGB(248, 248, 248)】
        config.ba_gridView_lineColor = BAKit_Color_Red_pod;
        // item：每行 item 的个数，默认为4个
        config.ba_gridView_rowCount = kGridView_rowCount2;
        // item：高度
        config.ba_gridView_itemHeight = kGridView_itemHeight2;
        config.ba_gridView_itemWidth = 0;
        
        // item：图片与文字间距（或者两行文字类型的间距），默认：0
        //            config.ba_gridView_itemImageInset = 10;
        //  item：title 颜色，默认：BAKit_Color_Black【[UIColor blackColor]】
        config.ba_gridView_titleColor = BAKit_Color_Black_pod;
        //  item：Desc 颜色，默认：BAKit_Color_Gray_9【BAKit_Color_RGB(216, 220, 228)】
        config.ba_gridView_titleDescColor = BAKit_Color_Gray_7_pod;
        // item：title Font，默认：图文样式下 16，两行文字下（上25，下12）
        config.ba_gridView_titleFont = [UIFont boldSystemFontOfSize:25];
        // item：Desc Font，默认：两行文字下 12
        config.ba_gridView_titleDescFont = [UIFont boldSystemFontOfSize:15];
        // item：背景颜色，默认：BAKit_Color_White
        config.ba_gridView_backgroundColor = [UIColor yellowColor];
        // item：背景选中颜色，默认：无色
        config.ba_gridView_selectedBackgroundColor = [UIColor greenColor];
        
        
        // badge
        config.ba_gridView_badgeType = kBAGridViewBadgeType_Center;
        config.ba_gridView_badgeFont = [UIFont systemFontOfSize:10];
        config.ba_gridView_badgeRectCorners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight;
        //        config.ba_gridView_badgeCornerRadius = 3;
        //        config.ba_gridView_badgeBgColor = UIColor.orangeColor;
        //        config.ba_gridView_badgeTextColor = UIColor.greenColor;
        //        config.ba_gridView_badgeHeight = 30;
        //        config.ba_gridView_badgeOffsetPoint = CGPointMake(10, -10);
        
        config.dataArray = self.gridDataArray2;
        
        BAKit_WeakSelf
        config.onGridScrollViewDidScroll = ^(UIScrollView *scrollView) {
            
            NSInteger itemIndex = BAKit_GetScrollViewCurrentPage(scrollView);
            itemIndex = itemIndex;
            NSLog(@"itemIndex：%ld", (long)itemIndex);
        };
        _gridView2 = [BAGridView ba_creatGridViewWithGridViewConfig:config block:^(BAGridItemModel *model, NSIndexPath *indexPath) {
            BAKit_StrongSelf
            BAKit_ShowAlertWithMsg_ios8(model.titleString);
        }];
        
    }
    return _gridView2;
}

- (NSMutableArray <BAGridItemModel *> *)gridDataArray {
    if (!_gridDataArray) {
        _gridDataArray = @[].mutableCopy;
        
        BAGridView_Config *config = self.ba_GridViewConfig;
        
        // 可以为本地图片
        //        NSArray *imageNameArray = @[@"tabbar_mainframeHL", @"tabbar_mainframeHL", @"tabbar_mainframeHL", @"tabbar_mainframeHL", @"tabbar_mainframeHL"];
        // 也可以是网络图片
        
        NSArray *imageNameArray;
        NSArray *bgImageNameArray;
        
        if (config.gridViewType == BAGridViewTypeBgImageTitle) {
            bgImageNameArray = @[@"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg",
                                 @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg",
                                 @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg",
                                 @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg",
                                 @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg"
            ];
        } else {
            imageNameArray = @[@"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg",
                               @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd41.jpg",
                               @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd442.jpg",
                               @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd443.jpg",
                               @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg"
            ];
        }
        
        if (config.gridViewType == BAGridViewTypeImageTitle || config.gridViewType == BAGridViewTypeTitleImage) {
            bgImageNameArray = @[
                @"http://img.qq1234.org/uploads/allimg/161212/16012W921-11.jpg",
                @"http://img.qq1234.org/uploads/allimg/161212/16012W921-11.jpg",
                @"http://img.qq1234.org/uploads/allimg/161212/16012W921-11.jpg",
                @"http://img.qq1234.org/uploads/allimg/161212/16012W921-11.jpg",
                @"http://img.qq1234.org/uploads/allimg/161212/16012W921-11.jpg",
            ];
        }
        
        NSArray *titleArray = @[@"小区tabbar_main", @"商圈", @"社交57128423", @"出行", @"武术"];
        
        for (NSInteger i = 0; i < titleArray.count; i++) {
            BAGridItemModel *model = [BAGridItemModel new];
            if (imageNameArray.count > 0) {
                //                model.imageName = imageNameArray[i];
            }
            if (bgImageNameArray.count > 0) {
                model.bgImageName = bgImageNameArray[i];
            }
            model.titleString = titleArray[i];
            
            if (config.gridViewType == BAGridViewTypeImageTitle) {
                NSInteger a = BAKit_RandomNumber(2000);
                model.badge = a == 0 ? @"": @(a).stringValue;
                if (i == 1) {
                    model.badge = @"新功能";
                }
            }
            
            [self.gridDataArray addObject:model];
        }
    }
    return _gridDataArray;
}

- (NSMutableArray <BAGridItemModel *> *)gridDataArray2 {
    if (!_gridDataArray2) {
        _gridDataArray2 = @[].mutableCopy;
        
        NSArray *titleArray = @[@"200", @"20", @"200",
                                @"10", @"￥3899989", @"30",
                                @"10", @"300", @"30", ];
        NSArray *descArray = @[@"1新增积分总量",
                               @"2返还积分总量",
                               @"3全返单元总量",
                               @"4每单元返还积分",
                               @"5全返单元总量",
                               @"6每单元返还积分",
                               @"7每单元返还积分",
                               @"8全返单元总量",
                               @"9每单元返还积分"];
        
        for (NSInteger i = 0; i < titleArray.count; i++) {
            BAGridItemModel *model = [BAGridItemModel new];
            model.desc = descArray[i];
            if (i == 4) {
                //初始化一个attriburitedString对象
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:titleArray[i]];
                //给这个属性添加一个属性前3个字符的背景颜色
                NSRange orRange = NSMakeRange(0, 1);
                [attributeString addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont systemFontOfSize:11]} range:orRange];
              
                //添加多个属性
                NSRange seRange = NSMakeRange(3, 2);
                [attributeString addAttributes:@{ NSForegroundColorAttributeName: [UIColor redColor], NSBackgroundColorAttributeName: [UIColor blueColor]} range:seRange];
                
                model.titleAttributedString = attributeString;
                model.badge = @"+39";
            } else {
                model.titleString = titleArray[i];
                model.badge = @"新增20";
            }
            
            [_gridDataArray2 addObject:model];
        }
    }
    return _gridDataArray2;
}

@end
