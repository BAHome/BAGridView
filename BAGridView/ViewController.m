//
//  ViewController.m
//  BAGridView
//
//  Created by boai on 2017/6/12.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "ViewController.h"
#import "BAKit_BAGridView.h"
#import "BAGridView_Config.h"
static NSString * const kCellID = @"ViewControllerCell";

#define kGridView_rowCount   4
#define kGridView_itemHeight 100
#define kGridView_H          BAKit_getColumnCountWithArrayAndRowCount_pod(self.gridDataArray, kGridView_rowCount) * kGridView_itemHeight

#define kGridView_rowCount2   2
#define kGridView_itemHeight2 80
#define kGridView_H2          BAKit_getColumnCountWithArrayAndRowCount_pod(self.gridDataArray2, kGridView_rowCount2) * kGridView_itemHeight2

static NSString * const kUrl1 = @"http://fc.topitme.com/c/08/e1/11235427029dbe108cm.jpg";
static NSString * const kUrl2 = @"http://pic.58pic.com/58pic/12/68/14/87w58PIC3hU.jpg";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"BAGridView";
    self.view.backgroundColor = BAKit_Color_White_pod;
    self.isSelectCell = NO;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    
    NSString *msg = [@(indexPath.row + 1).stringValue stringByAppendingString:@"、"];
    cell.textLabel.text = [msg stringByAppendingString:self.dataArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.gridView = nil;
    self.gridDataArray = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            self.isSelectCell = !self.isSelectCell;
            if (self.isSelectCell)
            {
                self.ba_GridViewConfig.gridViewType = BAGridViewTypeTitleImage;
                cell.textLabel.text = @"1、图上文下(点击更换样式)";
            }
            else
            {
                self.ba_GridViewConfig.gridViewType = BAGridViewTypeImageTitle;
                cell.textLabel.text = @"1、文上图下(点击更换样式)";
            }
            
            UIView *footView = [UIView new];
            footView.backgroundColor = [UIColor redColor];
            footView.frame = CGRectMake(0, 20, BAKit_SCREEN_WIDTH, kGridView_H);
            self.gridView.frame = footView.bounds;
            [footView addSubview:self.gridView];
            
            self.tableView.tableFooterView = footView;
        }
            break;
        case 1:
        {
            self.ba_GridViewConfig.gridViewType = BAGridViewTypeBgImageTitle;

            UIView *footView = [UIView new];
            footView.backgroundColor = [UIColor redColor];
            footView.frame = CGRectMake(0, 20, BAKit_SCREEN_WIDTH, kGridView_H);
            self.gridView.frame = footView.bounds;
            [footView addSubview:self.gridView];
            
            self.tableView.tableFooterView = footView;
        }
            break;
        case 2:
        {
            self.ba_GridViewConfig.gridViewType = BAGridViewTypeTitleDesc;
            UIView *footView = [self.view viewWithTag:102];

            if (!footView)
            {
                footView = [UIView new];
                footView.backgroundColor = [UIColor redColor];
                footView.frame = CGRectMake(0, 20, BAKit_SCREEN_WIDTH, kGridView_H2);
                footView.tag = 102;
                self.gridView2.frame = footView.bounds;
                [footView addSubview:self.gridView2];
            }

            self.tableView.tableFooterView = footView;
        }
            break;
            
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    
}

#pragma mark - setter / getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
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

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[@"图上文下 / 文上图下(点击更换样式)", @"带背景图片，中间是文字", @"两行文字"];
    }
    return _dataArray;
}

- (BAGridView_Config *)ba_GridViewConfig {
    if (!_ba_GridViewConfig) {
        _ba_GridViewConfig = [[BAGridView_Config alloc] init];
    }
    return _ba_GridViewConfig;
}

- (BAGridView *)gridView
{
    if (!_gridView)
    {
        // 是否显示分割线
        self.ba_GridViewConfig.showLineView = YES;
        // item：分割线颜色，默认：BAKit_Color_Gray_11【BAKit_Color_RGB(248, 248, 248)】
        self.ba_GridViewConfig.ba_gridView_lineColor = BAKit_Color_Red_pod;
        // item：每行 item 的个数，默认为4个
        self.ba_GridViewConfig.ba_gridView_rowCount = kGridView_rowCount;
        // item：高度
        self.ba_GridViewConfig.ba_gridView_itemHeight = kGridView_itemHeight;
        // item：图片与文字间距（或者两行文字类型的间距），默认：0
        self.ba_GridViewConfig.ba_gridView_itemImageInset = 5;
        //  item：title 颜色，默认：BAKit_Color_Black【[UIColor blackColor]】
        //            self.ba_GridViewConfig.ba_gridView_titleColor = BAKit_Color_Black;
        // item：title Font，默认：图文样式下 16，两行文字下（上25，下12）
        self.ba_GridViewConfig.ba_gridView_titleFont = [UIFont boldSystemFontOfSize:15];
        // item：背景颜色，默认：BAKit_Color_White
        self.ba_GridViewConfig.ba_gridView_backgroundColor = [UIColor yellowColor];
        // item：背景选中颜色，默认：无色
        self.ba_GridViewConfig.ba_gridView_selectedBackgroundColor = BAKit_Color_Red_pod;
        self.ba_GridViewConfig.dataArray = self.gridDataArray;

        _gridView = [BAGridView ba_creatGridViewWithGridViewConfig:self.ba_GridViewConfig block:^(BAGridItemModel *model, NSIndexPath *indexPath) {
            
            BAKit_ShowAlertWithMsg_ios8(model.titleString);
        }];
    }
    return _gridView;
}

- (BAGridView *)gridView2
{
    if (!_gridView2)
    {
        // item：分割线颜色，默认：BAKit_Color_Gray_11【BAKit_Color_RGB(248, 248, 248)】
        self.ba_GridViewConfig.ba_gridView_lineColor = BAKit_Color_Red_pod;
        // item：每行 item 的个数，默认为4个
        self.ba_GridViewConfig.ba_gridView_rowCount = kGridView_rowCount2;
        // item：高度
        self.ba_GridViewConfig.ba_gridView_itemHeight = kGridView_itemHeight2;
        // item：图片与文字间距（或者两行文字类型的间距），默认：0
        //            self.ba_GridViewConfig.ba_gridView_itemImageInset = 10;
        //  item：title 颜色，默认：BAKit_Color_Black【[UIColor blackColor]】
        self.ba_GridViewConfig.ba_gridView_titleColor = BAKit_Color_Black_pod;
        //  item：Desc 颜色，默认：BAKit_Color_Gray_9【BAKit_Color_RGB(216, 220, 228)】
        self.ba_GridViewConfig.ba_gridView_titleDescColor = BAKit_Color_Gray_7_pod;
        // item：title Font，默认：图文样式下 16，两行文字下（上25，下12）
        self.ba_GridViewConfig.ba_gridView_titleFont = [UIFont boldSystemFontOfSize:25];
        // item：Desc Font，默认：两行文字下 12
        self.ba_GridViewConfig.ba_gridView_titleDescFont = [UIFont boldSystemFontOfSize:15];
        // item：背景颜色，默认：BAKit_Color_White
        self.ba_GridViewConfig.ba_gridView_backgroundColor = [UIColor yellowColor];
        // item：背景选中颜色，默认：无色
        self.ba_GridViewConfig.ba_gridView_selectedBackgroundColor = [UIColor greenColor];
        self.ba_GridViewConfig.dataArray = self.gridDataArray2;
        
        _gridView2 = [BAGridView ba_creatGridViewWithGridViewConfig:self.ba_GridViewConfig block:^(BAGridItemModel *model, NSIndexPath *indexPath) {
            
            BAKit_ShowAlertWithMsg_ios8(model.titleString);
        }];
    }
    return _gridView2;
}

- (NSMutableArray <BAGridItemModel *> *)gridDataArray
{
    if (!_gridDataArray)
    {
        _gridDataArray = @[].mutableCopy;
        
        // 可以为本地图片
//        NSArray *imageNameArray = @[@"tabbar_mainframeHL", @"tabbar_mainframeHL", @"tabbar_mainframeHL", @"tabbar_mainframeHL", @"tabbar_mainframeHL"];
        // 也可以是网络图片
        
        NSArray *imageNameArray;
        if (self.ba_GridViewConfig.gridViewType == BAGridViewTypeBgImageTitle)
        {
            imageNameArray = @[@"http://img.qq1234.org/uploads/allimg/161212/16012W921-11.jpg",
                               @"http://d.hiphotos.baidu.com/image/pic/item/b21c8701a18b87d67cda2ef50d0828381e30fd44.jpg",
                               @"http://fc.topitme.com/c/08/e1/11235427029dbe108cm.jpg",
                               @"http://120.24.177.96:1525/images/20170706/91c9e2ba-9493-4009-8f3d-e613350b7c17.png",
                               @"http://120.24.177.96:1525/images/20170706/d36ab2cb-36e3-4492-89c8-5712848dadb8.png"];
        }
        else
        {
            imageNameArray = @[@"http://120.24.177.96:1525/images/20170706/b2acbae9-020c-4eaa-87b4-f7286ae69ba1.png",
                               @"http://120.24.177.96:1525/images/20170706/ae3a4188-f01a-442e-aaf0-94739e30b698.png",
                               @"http://120.24.177.96:1525/images/20170706/d4c88154-eaed-441a-8c8a-89d9a6d4755e.png",
                               @"http://120.24.177.96:1525/images/20170706/91c9e2ba-9493-4009-8f3d-e613350b7c17.png",
                               @"http://120.24.177.96:1525/images/20170706/d36ab2cb-36e3-4492-89c8-5712848dadb8.png"];
        }
        NSArray *titleArray = @[@"小区tabbar_main", @"商圈", @"社交57128423", @"出行", @"武术"];
        
        for (NSInteger i = 0; i < titleArray.count; i++)
        {
            BAGridItemModel *model = [BAGridItemModel new];
            model.imageName = imageNameArray[i];
            model.placdholderImageName = @"tabbar_mainframeHL";
            model.titleString = titleArray[i];
            
            [self.gridDataArray addObject:model];
        }
    }
    return _gridDataArray;
}

- (NSMutableArray <BAGridItemModel *> *)gridDataArray2
{
    if (!_gridDataArray2)
    {
        _gridDataArray2 = @[].mutableCopy;
        
        NSArray *titleArray = @[@"200", @"20", @"200", @"10", ];
        NSArray *descArray = @[@"新增积分总量", @"返还积分总量", @"全返单元总量", @"每单元返还积分"];
        
        for (NSInteger i = 0; i < titleArray.count; i++)
        {
            BAGridItemModel *model = [BAGridItemModel new];
            model.desc = descArray[i];
            model.titleString = titleArray[i];
            
            [_gridDataArray2 addObject:model];
        }
    }
    return _gridDataArray2;
}

@end
