//
//  QSItemView.h
//  QSSlideView
//
//  Created by wuqiushan3@163.com on 2019/4/18.
//  Copyright © 2019 wuqiushan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//#pragma mark === 引用循环
#define IOSPageWeakSelf    __weak __typeof(self)weakSelf = self;
#define IOSPageStrongSelf  __strong __typeof(weakSelf)strongSelf = weakSelf;

typedef NS_ENUM(NSInteger, IOSItemStyle) {
    IOSItemStyleTotalSolidItemEqual, /** 总长度固定，item长度均分 */
    IOSItemStyleTotalSlidItemFont,   /** 总长度可变，item长度根据字体大小算出来 */
    IOSItemStyleTotalSlidItemSolid,  /** 总长度可变，item长度固定 */
};

typedef NS_ENUM(NSInteger, IOSSplitStyle) {
    IOSSplitStyleVerticalLine, /** 分隔视图显示竖线 */
    IOSSplitStyleDot,          /** 分隔视图显示圆点 */
};

@interface QSItemView : UIView

/** 点击事件 */
@property (nonatomic, copy) void(^ClickIndex)(NSUInteger index);

/**
 创建头部视图用户可以自定义各种样式

 @param frame 头部视图的布局大小
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
                    ItemStyle:(IOSItemStyle)itemStyle
                   titleArray:(NSArray <NSString *>*)titleArray
                   titleColor:(UIColor *)titleColor
             titleSelectColor:(UIColor *)selectColor
                    titleFont:(CGFloat)fontSize
                    splitShow:(BOOL)splitShow
                   splitStyle:(IOSSplitStyle)splitStyle
                 positionShow:(BOOL)positionShow
                positionColor:(UIColor *)positionColor;

// 设置item的当前的位置，被内容视图左右滑动影响，item点击也会内容视图的变化
- (void)setItemIndex:(NSUInteger)index;


/**
 有些场景需要更新标题比如：歌曲(100) 数字100可能需要变化

 @param titleArray 标题
 */
- (void)updateTitleArray:(NSArray <NSString *>*)titleArray;

@end

NS_ASSUME_NONNULL_END
