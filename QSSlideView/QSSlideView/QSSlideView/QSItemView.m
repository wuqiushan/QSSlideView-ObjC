//
//  QSItemView.m
//  QSSlideView
//
//  Created by wuqiushan3@163.com on 2019/4/18.
//  Copyright © 2019 wuqiushan. All rights reserved.
//  后面应该需要更多的自定义，比如正常显示和按下的字体颜色，大小，指示器颜色或者隐藏等

#import "QSItemView.h"
#import "QSSlideView.h"

#define SplitViewW 10.0  /** 分隔视图的宽度 */
#define SplitViewY 10.0  /** 分隔视图原点Y坐标 */

@interface QSItemView()
@property(nonatomic, strong) UIView    *positionView;     /** 指示当前的位置的指示器 */
@property(nonatomic, strong) UIView    *bottomSplitView;  /** 底部分隔视图 */
@property(nonatomic, strong) UIButton  *preButton;        /** 前一次选中的按钮 */
@property(nonatomic, strong) UIColor   *titleColor;       /** 标题正常颜色 */
@property(nonatomic, strong) UIColor   *titleSelectColor; /** 标题选中颜色 */
@property(nonatomic, assign) CGFloat    titleFontSize;    /** 标题字体大小 */
@property(nonatomic, assign) BOOL       isShowSplit;      /** 是否显示分隔视图 */
@end

@implementation QSItemView

- (instancetype)initWithFrame:(CGRect)frame
                    ItemStyle:(IOSItemStyle)itemStyle
                   titleArray:(NSArray <NSString *>*)titleArray
                   titleColor:(UIColor *)titleColor
             titleSelectColor:(UIColor *)selectColor
                    titleFont:(CGFloat)fontSize
                    splitShow:(BOOL)splitShow
                   splitStyle:(IOSSplitStyle)splitStyle
                 positionShow:(BOOL)positionShow
                positionColor:(UIColor *)positionColor
{
    self = [super init];
    if (self) {
        //self.backgroundColor = [UIColor greenColor];
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        [self setupViewWithItemStyle:itemStyle
                          titleArray:titleArray
                          titleColor:titleColor
                    titleSelectColor:selectColor
                           titleFont:fontSize
                           splitShow:splitShow
                          splitStyle:splitStyle
                        positionShow:positionShow
                       positionColor:positionColor];
    }
    return self;
}

- (void)setupViewWithItemStyle:(IOSItemStyle)itemStyle
                    titleArray:(NSArray <NSString *>*)titleArray
                    titleColor:(UIColor *)titleColor
              titleSelectColor:(UIColor *)selectColor
                     titleFont:(CGFloat)fontSize
                     splitShow:(BOOL)splitShow
                    splitStyle:(IOSSplitStyle)splitStyle
                  positionShow:(BOOL)positionShow
                 positionColor:(UIColor *)positionColor
{
    /** 初始化全局配置 */
    self.isShowSplit  = splitShow;
    self.titleFontSize = fontSize;
    self.titleColor = titleColor;
    self.titleSelectColor = selectColor;
    
    if (titleArray.count < 1) { return ; }
    
    /** 计算每个button占用长度 分隔视图固定长度是10(个数是titleArray.count - 1) */
    CGFloat titleW = 0.0;
    if (itemStyle == IOSItemStyleTotalSolidItemEqual) {
        CGFloat splitTotalW = (titleArray.count - 1) * SplitViewW;
        titleW = (CGRectGetWidth(self.bounds) - splitTotalW) / titleArray.count;
    }
    else if (itemStyle == IOSItemStyleTotalSlidItemFont) {
        titleW = 100;
    }
    else if (itemStyle == IOSItemStyleTotalSlidItemSolid) {
        titleW = 100;
    }
    
    // 加载视图 里面视图结构为： |T|S|T|S|T|   T:titleButton S:splitView
    for (int j = 0; j < titleArray.count; j ++) {
        
        // 加载titleButton
        UIButton *titleButton = [self getTitleButtonWithFont:fontSize
                                                       title:titleArray[j]
                                                  titleColor:titleColor
                                            selectTitleColor:selectColor];
        CGFloat titleButtonX = j * (SplitViewW + titleW);
        CGFloat titleButtonH = CGRectGetHeight(self.bounds) - (SplitViewY * 2);
        titleButton.frame = CGRectMake(titleButtonX, SplitViewY, titleW, titleButtonH);
        [self addSubview:titleButton];
        
        // 加载分隔视图, 最后一个时不显示(不创建)
        if ((self.isShowSplit) && (j != (titleArray.count - 1) )) {
            UIView *splitView = [self getSplitViewWithStyle:splitStyle];
            CGFloat splitViewX = titleButtonX + titleW;
            splitView.frame = CGRectMake(splitViewX, SplitViewY, SplitViewW, titleButtonH);
            [self addSubview:splitView];
        }
    }
    
    // 创建指示器
    if (positionShow) {
        self.positionView = [self getPositionViewWithColor:positionColor];
        IOSPageWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [weakSelf setItemIndex:0];
        });
        [self addSubview:self.positionView];
    }
    
    // 底部分隔线
    self.bottomSplitView = [self getBottomSplitView];
    [self addSubview:self.bottomSplitView];
}

// 设置item的当前的位置，被内容视图左右滑动影响，item点击也会内容视图的变化
- (void)setItemIndex:(NSUInteger)index {
    
    // 获取应该选中的button
    NSUInteger realIndex = self.isShowSplit == YES ? index * 2 : index;
    if (realIndex > self.subviews.count) { return ; }
    
    // 之因为这样操作，是因为在加载时，是依次加载的
    UIButton *titleButton = self.subviews[realIndex];
    if ([titleButton isKindOfClass:[UIButton class]]) {
        [self selectTitleButtonHandle:titleButton];
    }
}

#pragma mark 更新标题
- (void)updateTitleArray:(NSArray <NSString *>*)titleArray {
    
    /** 计算出UIButton的个数，在这里只有titleButton其它都不属于button */
    NSUInteger orgTitleCount = 0;
    for (UIButton *element in self.subviews) {
        if ([element isKindOfClass:[UIButton class]]) {
            orgTitleCount += 1;
        }
    }
    /** 更新和标题数如果不等于原有个数，不允许设置 */
    if (!(titleArray.count == orgTitleCount)) { return ; }
    
    for (int j = 0; j < titleArray.count; j ++) {
        /** 取出对应位置的button  |T|S|T|S|T| */
        NSUInteger elementIndex = self.isShowSplit == YES ? j * 2 : j;
        UIButton *titleButton = self.subviews[elementIndex];
        [titleButton setTitle:titleArray[j] forState:UIControlStateNormal];
    }
}

#pragma mark 按钮被点击
- (void)changeItemAction:(UIButton *)button {
    
    [self selectTitleButtonHandle:button];
    
    // 去告知容器视图点击是第几个index
    NSUInteger index = [self.subviews indexOfObject:button];
    if (self.isShowSplit) { index = index / 2; } // x.5 = x (x下标正常对应)
    if (self.ClickIndex) { self.ClickIndex(index); }
}

#pragma mark 按钮字体颜色和动画处理
- (void)selectTitleButtonHandle:(UIButton *)button {
    
    // **** 颜色
    // 把之前的button颜色复位正常，当前按下的为选中颜色
    if (self.preButton) {
        [self.preButton setTitleColor:self.titleColor forState:UIControlStateNormal];
    }
    self.preButton = button;
    [button setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
    
    // **** 动画
    // 获取button的位置和长度
    CGFloat buttonX = CGRectGetMinX(button.frame);
    CGFloat buttonW = CGRectGetWidth(button.frame);
    
    /** 宽度最小为20 */
    CGFloat textW = [self widthWithText:button.titleLabel.text
                                   font:[UIFont systemFontOfSize:self.titleFontSize]];
    textW = textW < 20.0 ? 20.0 : textW;
    /** 按钮x点到文字x的距离 */
    CGFloat buttonXtoTextX = (buttonW - textW) / 2.0;
    /** 动画目的地的x坐标为 */
    CGFloat toX = buttonX + buttonXtoTextX;
    
    // 动画到选中的文字正下面
    IOSPageWeakSelf
    if (self.positionView) {
        [UIView transitionWithView:self.positionView duration:0.2 options:0 animations:^{
            weakSelf.positionView.frame = CGRectMake(toX, CGRectGetHeight(weakSelf.bounds) - 7, textW, 2);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark 获取Button
- (UIButton *)getTitleButtonWithFont:(CGFloat)size title:(NSString *)title
                          titleColor:(UIColor *)titleColor
                    selectTitleColor:(UIColor *)selectColor  {
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.contentMode = UIViewContentModeCenter;
    [titleButton setTitleColor:titleColor forState:UIControlStateNormal];
    [titleButton setTitleColor:selectColor forState:UIControlStateHighlighted];
    [titleButton setTitle:title forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:size];
    //titleButton.backgroundColor = [UIColor yellowColor];
    titleButton.backgroundColor = [UIColor clearColor];
    [titleButton addTarget:self action:@selector(changeItemAction:)
          forControlEvents:UIControlEventTouchUpInside];
    return titleButton;
}

#pragma mark 获取指示器
- (UIView *)getPositionViewWithColor:(UIColor *)color {
    
    UIView *positionView = [[UIView alloc] initWithFrame:CGRectZero];
    positionView.layer.masksToBounds = YES;
    positionView.layer.cornerRadius = 0.2;
    positionView.backgroundColor = color;
    return positionView;
}

#pragma mark 分隔视图
- (UIView *)getSplitViewWithStyle:(IOSSplitStyle)splitStyle {
    
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectZero];
    //splitView.backgroundColor = [UIColor whiteColor];
    splitView.backgroundColor = [UIColor clearColor];
    
    CGFloat splitViewH = CGRectGetHeight(self.bounds) - (SplitViewY * 2);
    UIView *decoView = [[UIView alloc] init];
    decoView.backgroundColor = [UIColor lightGrayColor];
    [splitView addSubview:decoView];
    
    if (splitStyle == IOSSplitStyleDot) {
        CGFloat decoViewX = (SplitViewW / 2.0) - (5.0 / 2.0);
        CGFloat decoViewY = (splitViewH / 2.0) - (5.0 / 2.0);
        decoView.frame = CGRectMake(decoViewX, decoViewY, 5, 5);
        decoView.layer.masksToBounds = YES;
        decoView.layer.cornerRadius = 2.5;
    }
    else if (splitStyle == IOSSplitStyleVerticalLine) {
        CGFloat decoViewX = (SplitViewW / 2.0) - (1.0 / 2.0);
        CGFloat decoViewY = (splitViewH / 2.0) - (8.0 / 2.0);
        decoView.frame = CGRectMake(decoViewX, decoViewY, 1, 8);
    }
    return splitView;
}

- (UIView *)getBottomSplitView {
    CGRect rect = CGRectMake(0, CGRectGetHeight(self.bounds) - 5, CGRectGetWidth(self.bounds), 5);
    UIView *bottomSplitView = [[UIView alloc] initWithFrame:rect];
    bottomSplitView.backgroundColor = [UIColor colorWithRed:0xef / 255.0 green:0xef / 255.0
                                                 blue:0xef / 255.0 alpha:1.0];
    return bottomSplitView;
}

// 工具类方法
-(CGFloat)widthWithText:(NSString *)text font:(UIFont *)font
{
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs context:nil].size.width;
}

@end
