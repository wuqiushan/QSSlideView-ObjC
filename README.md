[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
本框架当前较流行的左右滑动页视图框架

### 使用方法
```Objective-C
- (void)setupView {
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
```
![](https://github.com/wuqiushan/QSSlideView-ObjC/blob/master/QSSlideView.gif)

### 许可证
所有源代码均根据MIT许可证进行许可。