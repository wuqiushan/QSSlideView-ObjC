//
//  QSSlideView.m
//  QSSlideView
//
//  Created by wuqiushan3@163.com on 2019/4/17.
//  Copyright © 2019 wuqiushan. All rights reserved.
//

#import "QSSlideView.h"

@interface QSSlideView()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollItemView;
@property(nonatomic, strong) UIScrollView *scrollContentView;
@property(nonatomic, strong) QSItemView *itemView;

@property(nonatomic, strong) UIView   *leftView;
@property(nonatomic, strong) UIView   *middleView;
@property(nonatomic, strong) UIView   *rightView;

@property(nonatomic, assign) NSUInteger currentIndex;  /** 当前显示的index */
@property(nonatomic, copy) NSMutableArray<UIView *> *subViewArray; /** 存放子视图数组 */
@property(nonatomic, copy) NSMutableArray<NSString *> *titleArray; /** 存放子视图标题数组 */

@end

@implementation QSSlideView

/** 头部item高度 和 内容视图高度 */
#define ItemViewH            55.0
#define ContentViewH(totalH) totalH - ItemViewH

- (instancetype)initWithFrame:(CGRect)frame
                 SubViewArray:(NSArray <UIView *> *)subViewArray
                   titleArray:(NSArray <NSString *>*)titleArray {
    return [self initWithFrame:frame
                  SubViewArray:subViewArray
                     ItemStyle:IOSItemStyleTotalSolidItemEqual
                    titleArray:titleArray
                    titleColor:[UIColor colorWithRed:0x93 / 255.0 green:0x93 / 255.0 blue:0x93 / 255.0 alpha:1.0]
              titleSelectColor:[UIColor colorWithRed:0x26 / 255.0 green:0x12 / 255.0 blue:0x0B / 255.0 alpha:1.0]
                     titleFont:18
                     splitShow:NO
                    splitStyle:IOSSplitStyleDot
                  positionShow:YES
                 positionColor:[UIColor colorWithRed:0x26 / 255.0 green:0x12 / 255.0 blue:0x0B / 255.0 alpha:1.0]];
}

- (instancetype)initWithFrame:(CGRect)frame
                 SubViewArray:(NSArray <UIView *> *)subViewArray
                    ItemStyle:(IOSItemStyle)itemStyle
                   titleArray:(NSArray <NSString *>*)titleArray
                   titleColor:(UIColor *)titleColor
             titleSelectColor:(UIColor *)selectColor
                    titleFont:(CGFloat)fontSize
                    splitShow:(BOOL)splitShow
                   splitStyle:(IOSSplitStyle)splitStyle
                 positionShow:(BOOL)positionShow
                positionColor:(UIColor *)positionColor {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollItemView];
        [self addSubview:self.scrollContentView];
        
        CGFloat viewWidth  = CGRectGetWidth(self.bounds);
        CGFloat viewHeight = CGRectGetHeight(self.bounds);
        self.scrollItemView.frame = CGRectMake(0, 0, viewWidth, ItemViewH);
        self.scrollContentView.frame = CGRectMake(0, ItemViewH, viewWidth, ContentViewH(viewHeight));
        [self updateSubViewArray:subViewArray
                       ItemStyle:itemStyle
                      titleArray:titleArray
                      titleColor:titleColor
                titleSelectColor:selectColor
                       titleFont:fontSize
                       splitShow:splitShow
                      splitStyle:splitStyle
                    positionShow:positionShow
                   positionColor:positionColor];
        
        [self.scrollItemView addObserver:self
                              forKeyPath:@"contentOffset"
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
        [self.scrollContentView addObserver:self
                                 forKeyPath:@"contentOffset"
                                    options:NSKeyValueObservingOptionNew
                                    context:nil];
    }
    return self;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.scrollItemView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollContentView removeObserver:self forKeyPath:@"contentOffset"];
}

/**
 更新内容数组和善数组时，要重新布局

 @param subViewArray 需要显示的内容视图
 @param titleArray 需要显示内容视图对应的title
 */
- (void)updateSubViewArray:(NSArray <UIView *> *)subViewArray
                 ItemStyle:(IOSItemStyle)itemStyle
                titleArray:(NSArray <NSString *>*)titleArray
                titleColor:(UIColor *)titleColor
          titleSelectColor:(UIColor *)selectColor
                 titleFont:(CGFloat)fontSize
                 splitShow:(BOOL)splitShow
                splitStyle:(IOSSplitStyle)splitStyle
              positionShow:(BOOL)positionShow
             positionColor:(UIColor *)positionColor {
    
    if (subViewArray.count < 1) { return ; }
    if (subViewArray.count != titleArray.count) { return ; }
    
    CGFloat viewWidth  = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    
    [self.scrollContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollItemView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 初始头部视图
    self.itemView = [[QSItemView alloc] initWithFrame:self.scrollItemView.bounds
                                             ItemStyle:itemStyle
                                            titleArray:titleArray
                                            titleColor:titleColor
                                      titleSelectColor:selectColor
                                             titleFont:fontSize
                                             splitShow:splitShow
                                            splitStyle:splitStyle
                                          positionShow:positionShow
                                         positionColor:positionColor];
    self.scrollItemView.contentSize = self.itemView.bounds.size;
    [self.scrollItemView addSubview:self.itemView];
    IOSPageWeakSelf
    self.itemView.ClickIndex = ^(NSUInteger index) {
        weakSelf.currentIndex = index;
    };
    
    // 需要显示的内容视图初始化为容器的大小，这样w使用都无需要设置内容视图的大小
    [self.subViewArray removeAllObjects];
    [self.titleArray removeAllObjects];
    for (UIView *elementView in subViewArray) {
        elementView.frame = CGRectMake(0, 0, viewWidth, ContentViewH(viewHeight));
        [self.subViewArray addObject:elementView];
    }
    [self.titleArray addObjectsFromArray:titleArray];
    
    // 计算scrollContentView内容大小
    if (titleArray.count < 3) {
        self.scrollContentView.contentSize = CGSizeMake(viewWidth * titleArray.count, ContentViewH(viewHeight));
    }
    else {
        self.scrollContentView.contentSize = CGSizeMake(viewWidth * 3, ContentViewH(viewHeight));
    }
    
    // 递增式加载视图到scrollContentView， 1，2时比较特殊
    if (titleArray.count >= 1) {
        [self.scrollContentView addSubview:self.leftView];
        self.leftView.frame   = CGRectMake(viewWidth * 0, 0, viewWidth, ContentViewH(viewHeight));
    }
    if (titleArray.count >= 2) {
        [self.scrollContentView addSubview:self.middleView];
        self.middleView.frame = CGRectMake(viewWidth * 1, 0, viewWidth, ContentViewH(viewHeight));
    }
    if (titleArray.count >= 3) {
        [self.scrollContentView addSubview:self.rightView];
        self.rightView.frame  = CGRectMake(viewWidth * 2, 0, viewWidth, ContentViewH(viewHeight));
    }
    
    // 调用其set方法初始化
    self.currentIndex = 0;
}

#pragma mark 设置当前的显示的视图(这里要考虑到小于3个界面的情况)
- (void)setCurrentIndex:(NSUInteger)currentIndex {
    
    if (self.subViewArray.count < 1) { return ; }
    NSUInteger preSelectIndex = _currentIndex; /** 记录上一次的位置 */
    _currentIndex = currentIndex;
    //NSLog(@"在第 %ld 页面", _currentIndex);
    
    /** 需要显示的内容为1个时 */
    if (self.subViewArray.count == 1) {
        [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.leftView addSubview:_subViewArray[0]];
    }
    /** 需要显示的内容为2个时 */
    else if (self.subViewArray.count == 2) {
        [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.middleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.leftView addSubview:_subViewArray[0]];
        [self.middleView addSubview:_subViewArray[1]];
        if (_currentIndex == 0) {
            self.scrollContentView.contentOffset = CGPointMake(0, 0);
        }
        else {
            self.scrollContentView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        }
    }
    /** 需要显示的内容为3个或者以上时 */
    else {
        [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.middleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (_currentIndex == 0) {
            [self.leftView addSubview:_subViewArray[0]];
            [self.middleView addSubview:_subViewArray[1]];
            [self.rightView addSubview:_subViewArray[2]];
            
            self.scrollContentView.contentOffset = CGPointMake(0, 0);
        }
        else if (_currentIndex == (_subViewArray.count - 1)) {
            [self.leftView addSubview:_subViewArray[_currentIndex - 2]];
            [self.middleView addSubview:_subViewArray[_currentIndex - 1]];
            [self.rightView addSubview:_subViewArray[_currentIndex]];
            
            self.scrollContentView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds) * 2.0, 0);
        }
        else {
            NSInteger arrayCount = _subViewArray.count;
            NSInteger leftIndex  = (currentIndex + arrayCount - 1) % arrayCount;
            NSInteger rightIndex = (currentIndex + 1) % arrayCount;
            
            [self.leftView addSubview:_subViewArray[leftIndex]];
            [self.middleView addSubview:_subViewArray[currentIndex]];
            [self.rightView addSubview:_subViewArray[rightIndex]];
            
            self.scrollContentView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        }
    }
    
    /** 获取上次和本次选中的视图及位置 */
    UIView *selectView = nil;
    UIView *preSelectView = nil;
    if (_currentIndex < _subViewArray.count) {
        selectView = _subViewArray[_currentIndex];
    }
    if (preSelectIndex < _subViewArray.count ) {
        preSelectView = _subViewArray[preSelectIndex];
    }
    if ((selectView == nil) || (preSelectView == nil)) {
        return ;
    }
    
    // 选中事件通过block传递
    if (self.didSelectAction) {
        self.didSelectAction(_currentIndex, selectView);
    }
    if (self.didDetailSelectAction) {
        self.didDetailSelectAction(_currentIndex, selectView, preSelectIndex, preSelectView);
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    // 非位移的KVO不处理
    if (![keyPath isEqualToString:@"contentOffset"]) { return; }
    if (object == self.scrollItemView) {
        // item下划线的动画处理
    }
    else if (object == self.scrollContentView) {
        
        CGFloat pointX = self.scrollContentView.contentOffset.x;
        CGFloat criticalValue = 0.2f;
        if (self.subViewArray.count <= 1) {
            return ;
        }
        else if (self.subViewArray.count == 2) {
            /**
             *  滑动只有二种可能，从左向右(在右边界)、从右向左(在左边界)
             */
            
            // 手指从右向左(在左边界) middleView将要完全显示
            if (_currentIndex == 0) {
                if (pointX > CGRectGetWidth(self.scrollContentView.bounds) - criticalValue) {
                    self.currentIndex = _currentIndex + 1;
                }
            }
            // 手指从左向右(在右边界) leftView将要完全显示
            else if (_currentIndex == (_subViewArray.count - 1)) {
                if (pointX < criticalValue) {
                    self.currentIndex = _currentIndex - 1;
                }
            }
            else {
                //NSLog(@"warning 异常1");
            }
        }
        else {
            /**
             *  滑动只有四种可能，从中间向左、从中间向右、从左向中(在左边界)、从右向中(在右边界)
             */
            
            // 手指从中间向左滑，rightView将要完全显示时，currentIndex指向的不是subViewArray最后的元素时
            if (pointX > 2 * CGRectGetWidth(self.scrollContentView.bounds) - criticalValue) {
                if (_currentIndex < (_subViewArray.count - 1)) {
                    self.currentIndex = _currentIndex + 1;
                }
            }
            // 手指从中间向右滑，leftView将要完全显示时，currentIndex指向的不是subViewArray首个元素时
            else if (pointX < criticalValue) {
                if (_currentIndex > 0) {
                    self.currentIndex = _currentIndex - 1;
                }
            }
            // 手指从左向中(在左边界) middleView将要完全显示
            else if (_currentIndex == 0) {
                if (pointX > CGRectGetWidth(self.scrollContentView.bounds) - criticalValue) {
                    self.currentIndex = _currentIndex + 1;
                }
            }
            // 手指从右向中(在右边界) middleView将要完全显示
            else if (_currentIndex == (_subViewArray.count - 1)) {
                if (pointX < CGRectGetWidth(self.scrollContentView.bounds) + criticalValue) {
                    self.currentIndex = _currentIndex - 1;
                }
            }
            else {
                //NSLog(@"warning 异常2");
            }
        }//else
        [self.itemView setItemIndex:_currentIndex];
    }
}

/** 更新标题组 */
- (void)updateTitleArray:(NSArray <NSString *>*)titleArray {
    [self.itemView updateTitleArray:titleArray];
}

#pragma mark scorllViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

#pragma mark 懒加载

-(UIScrollView *)scrollItemView {
    if (!_scrollItemView) {
        _scrollItemView = [[UIScrollView alloc] init];
        _scrollItemView.delegate = self;
        _scrollItemView.pagingEnabled = YES;
        _scrollItemView.showsHorizontalScrollIndicator = NO;
        _scrollItemView.showsVerticalScrollIndicator = NO;
        _scrollItemView.bounces = NO;
    }
    return _scrollItemView;
}

-(UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        _scrollContentView.delegate = self;
        _scrollContentView.pagingEnabled = YES;
        _scrollContentView.showsHorizontalScrollIndicator = NO;
        _scrollContentView.showsVerticalScrollIndicator = NO;
        _scrollContentView.bounces = NO;
    }
    return _scrollContentView;
}

-(UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
    }
    return _leftView;
}

-(UIView *)middleView {
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
    }
    return _middleView;
}

-(UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (NSMutableArray <UIView *>*)subViewArray {
    if (!_subViewArray) {
        _subViewArray = [[NSMutableArray alloc] init];
    }
    return _subViewArray;
}

- (NSMutableArray <NSString *>*)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

@end
