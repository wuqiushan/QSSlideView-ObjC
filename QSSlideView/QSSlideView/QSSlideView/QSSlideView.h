//
//  QSSlideView.h
//  QSSlideView
//
//  Created by wuqiushan3@163.com on 2019/4/17.
//  Copyright © 2019 wuqiushan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSSlideView : UIView


/**
 选中回调事件
 @param selectIndex 选中视图位置
 @param selectView 选中的视图
 */
@property (nonatomic, copy) void(^didSelectAction)(NSUInteger selectIndex, UIView *selectView);

/**
 选中回调详细事件（包含上一个视图）
 @param selectIndex 选中视图位置
 @param selectView 选中的视图
 @param preSelectIndex 上次选中视图位置
 @param preSelectView 上次选中的视图
 */
@property (nonatomic, copy) void(^didDetailSelectAction)(NSUInteger selectIndex, UIView *selectView, NSUInteger preSelectIndex, UIView *preSelectView);

/**
 创建视图，使用默认的参数进行

 @param frame 视图的布局大小
 @param subViewArray 需要显示的内容视图
 @param titleArray 需要显示的标题组
 @return 自定义后的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                 SubViewArray:(NSArray <UIView *> *)subViewArray
                   titleArray:(NSArray <NSString *>*)titleArray;

/**
 创建并自定义视图
 
 @param frame 视图的布局大小
 @param subViewArray 需要显示的内容视图
 @param itemStyle 头部的样式
 @param titleArray 需要显示的标题组
 @param titleColor 正常显示的标题颜色
 @param selectColor 选中显示的标题颜色
 @param fontSize 标题字体大小
 @param splitShow 分隔视图是否显示
 @param splitStyle 分隔视图样式
 @param positionShow 指示游标是否显示
 @param positionColor 指示游标颜色
 @return 自定义后的对象
 */
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
                positionColor:(UIColor *)positionColor;

/**
 有些场景需要更新标题比如：歌曲(100) 数字100可能需要变化
 
 @param titleArray 更新后的标题组
 */
- (void)updateTitleArray:(NSArray <NSString *>*)titleArray;

@end

NS_ASSUME_NONNULL_END





/** 使用示例
- (void)setupView {
    //    self.view.backgroundColor = [UIColor lightGrayColor];
    CGRect rect = CGRectMake(0, 100, self.view.bounds.size.width, 450);
    
    UIView *test1 = [[UIView alloc] init];
    test1.backgroundColor = [UIColor redColor];
    
    UIView *test2 = [[UIView alloc] init];
    test2.backgroundColor = [UIColor yellowColor];
    
    UIView *test3 = [[UIView alloc] init];
    test3.backgroundColor = [UIColor greenColor];
    
    UIView *test4 = [[UIView alloc] init];
    test4.backgroundColor = [UIColor blueColor];
    
    //    QSSlideView *pageView = [[QSSlideView alloc] initWithFrame:rect
    //                                                  SubViewArray:@[test1]
    //                                                    titleArray:@[@"test1"]];
    
    //    QSSlideView *pageView = [[QSSlideView alloc] initWithFrame:rect
    //                                                  SubViewArray:@[test1, test2]
    //                                                    titleArray:@[@"test1", @"test2"]];
    
    //    QSSlideView *pageView = [[QSSlideView alloc] initWithFrame:rect
    //                                                  SubViewArray:@[test1, test2, test3]
    //                                                    titleArray:@[@"test1", @"test2", @"test3"]];
    
    //    QSSlideView *pageView = [[QSSlideView alloc] initWithFrame:rect
    //                                                  SubViewArray:@[test1, test2, test3, test4]
    //                                                    titleArray:@[@"test1", @"test2", @"test3", @"test4"]];
    
    QSSlideView *pageView = [[QSSlideView alloc] initWithFrame:rect
                                                  SubViewArray:@[test1, test2, test3, test4]
                                                    titleArray:@[@"test1", @"test2", @"test3", @"test4"]];
    
    [self.view addSubview:pageView];
}
*/











