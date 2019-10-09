//
//  ViewController.m
//  QSSlideView
//
//  Created by wuqiushan on 2019/10/9.
//  Copyright © 2019 wuqiushan3@163.com. All rights reserved.
//

#import "ViewController.h"
#import "AlbumViewController.h"
#import "MusicViewController.h"
#import "QSSlideView/QSSlideView.h"

#define IOSScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define IOSScreenHeight         ([UIScreen mainScreen].bounds.size.height)
#define IOSScreenRatioW         IOSScreenWidth / 375.0f

#define isIphone5               (IOSScreenWidth == 320.f && IOSScreenHeight == 568.f ? YES : NO)
#define isIphoneX_XS            (IOSScreenWidth == 375.f && IOSScreenHeight == 812.f ? YES : NO)
#define isIphoneXR_XSMax        (IOSScreenWidth == 414.f && IOSScreenHeight == 896.f ? YES : NO)
#define isIphoneXLater          (isIphoneX_XS || isIphoneXR_XSMax)

#define IOSStatusBarHeight      (isIphoneXLater ? 44.f : 20.f)
#define IOSNavgationBarHeight   44.0f
#define IOSNavgationTotalHeight (IOSStatusBarHeight + IOSNavgationBarHeight)

#define IOSBottomSafeHeight     (isIphoneXLater ? 34.0f : 0.0f)
#define IOSTabBarHeight         49.0f
#define IOSTabBarTotalHeight    (IOSBottomSafeHeight + IOSTabBarHeight)

@interface ViewController ()

@property (nonatomic, strong) QSSlideView *pageView; /** 显示视图的容器 */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor grayColor];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

- (void)setupView {
    
//    UIBarButtonItem *recentItem = [UIBarButtonItem itemWithImage:YYDImageWithName(@"recent_icon") highImage:YYDImageWithName(@"recent_icon") target:self action:@selector(recentItemHandle)];
//    self.navigationItem.rightBarButtonItem = recentItem;
    
    MusicViewController *musicVC = [[MusicViewController alloc] init];
    AlbumViewController *albumVC = [[AlbumViewController alloc] init];
    MusicViewController *musicVCTwo = [[MusicViewController alloc] init];
    [self addChildViewController:musicVC];
    [self addChildViewController:albumVC];
    [self addChildViewController:musicVCTwo];
    
    CGRect rect = CGRectMake(0, IOSNavgationTotalHeight, IOSScreenWidth, IOSScreenHeight - IOSNavgationTotalHeight);
    NSArray *views = @[musicVC.view, albumVC.view, musicVCTwo.view];
    NSArray *titles = @[@"单曲(13)", @"专辑(8)", @"单曲2"];
    self.pageView = [[QSSlideView alloc] initWithFrame:rect SubViewArray:views
                                             ItemStyle:IOSItemStyleTotalSolidItemEqual titleArray:titles
                                            titleColor:[UIColor colorWithRed:0x93 / 255.0 green:0x93 / 255.0 blue:0x93 / 255.0 alpha:1.0]
                                      titleSelectColor:[UIColor colorWithRed:0x26 / 255.0 green:0x12 / 255.0 blue:0x0B / 255.0 alpha:1.0]
                                             titleFont:18 splitShow:NO splitStyle:IOSSplitStyleVerticalLine positionShow:YES
                                         positionColor:[UIColor colorWithRed:0x36 / 255.0 green:0x46 / 255.0 blue:0x5D / 255.0 alpha:1.0]];
    [self.view addSubview:self.pageView];
}


#pragma mark 事件
//- (void)recentItemHandle {
//    YYDFootprintViewController *footprintVC = [[YYDFootprintViewController alloc] init];
//    [self.navigationController pushViewController:footprintVC animated:YES];
//}

@end
