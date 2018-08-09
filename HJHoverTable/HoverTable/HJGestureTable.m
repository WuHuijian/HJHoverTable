//
//  HJGestureTable.m
//  HJHoverTable
//
//  Created by WHJ on 2018/8/8.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJGestureTable.h"

@implementation HJGestureTable

// 允许处理多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
}
@end
