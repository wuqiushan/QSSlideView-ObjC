[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![language](https://img.shields.io/badge/language-objective--c-green.svg)](1) 

### 概述
本框架当前较流行的左右滑动页视图框架
* [X] 可搭载无限个视图
* [X] 支持点击头部Item切换，支持手势左右切换
* [X] 样式高度自定义
* [ ] 头部Item布局大小固定，采用左右滑动

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

### 设计思路(有兴趣可以看)

#### 类说明
* QSItemView：这类实现头部视图，开放自定义样式接口有标题字体、颜色、选中颜色、分隔样式、游标颜色等。
* QSSlideView：该类实现了内容视图容器，以及头部视图容器和内容视图容器联动，可搭载任意数量的视图，主容器采用了两个UIScrollView，内容视图容器采用了3个子视图容器完成，分别为左、中、右视图容器，用户的目标视图组就是加载这3个视图容器上的，通KVO的方式来检测UIScrollView的偏移来计算手势方向和位置，切换左、中、右视图容器中的视图

#### 思路图解

1.父容器是两个UIScrollView，头部scrollView加载一个itemView容器，该容器根据用户设定的样式和项数自动创建，内容scrollView加载了最多3个子容器，要展示的视图用存在数组中，当需要显示的时候才拿出来加载到子容器中。
![image](https://github.com/wuqiushan/QSSlideView-ObjC/blob/master/容器图.jpg)

2.当展示1个视图时，只需要用1个子容器就行了，同时也没有手势和点击切换。
![image](https://github.com/wuqiushan/QSSlideView-ObjC/blob/master/搭载1个视图.jpg)

3.当展示2个视图时，需要用到2个子容器，左右手势有下面两种情况要考虑
![image](https://github.com/wuqiushan/QSSlideView-ObjC/blob/master/搭载2个视图.jpg)

4.当展示3个及以上视图时，需要用到3个子容器，左右手势分为下面4种情况
![image](https://github.com/wuqiushan/QSSlideView-ObjC/blob/master/搭载多个视图.jpg)