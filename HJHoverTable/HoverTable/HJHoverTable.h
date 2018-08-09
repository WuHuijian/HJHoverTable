//
//  HJHoverTable.h
//  HJHoverTable
//
//  Created by WHJ on 2018/8/8.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HJGestureTable.h"



/* Top 区间 */
struct HJTopLimit{
    CGFloat originTop;//起始高度
    CGFloat hoverTop; //悬停高度
};

typedef struct HJTopLimit HJTopLimit;

static inline HJTopLimit HJTopLimitMake(CGFloat originTop, CGFloat hoverTop)
{
     HJTopLimit p; p.originTop = originTop; p.hoverTop = hoverTop; return p;
}


@protocol HJHoverTableDelegate

@required
- (nonnull HJGestureTable *)gestureTable;
//返回头部距离父视图顶部高度限制
- (HJTopLimit)limitOfMarginTop;

@optional
//自定义悬停头部视图
- (UIView *)headerOfHoverTable;
//返回悬停头部视图高度
- (CGFloat)headerHOfHoverTable;
//返回配置好的table

@end

@interface HJHoverTable : UIScrollView

@property (nonatomic ,strong ,readonly) HJGestureTable * tableView;

@property (nonatomic ,strong ,readonly) UIView * hoverHeader;

@property (nonatomic ,strong ,readonly) UIView * wrapperView;

@property (nonatomic ,assign ,readonly) BOOL isHover;//是否悬停

@property (nonatomic, assign, readonly) CGFloat hoverHeaderH;//悬停视图Header高度

@property (nonatomic, assign, readonly) HJTopLimit topLimit;

/** 代理 **/
@property (nonatomic ,weak ,nullable) NSObject<HJHoverTableDelegate> * hoverTableDelegate;

@property (nonatomic ,weak ,nullable) id<UITableViewDelegate> tableDelegate;

@property (nonatomic ,weak ,nullable) id<UITableViewDataSource> tableDataSource;


/** 方法 **/
- (void)reloadData;

@end
